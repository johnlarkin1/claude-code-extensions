# Tauri Commands Reference

This reference provides detailed patterns and advanced examples for Tauri v2 commands.

## Command Argument Patterns

### Rust to JavaScript Naming Convention

Tauri automatically converts Rust snake_case to JavaScript camelCase:

```rust
#[tauri::command]
fn get_user_profile(user_id: String, include_avatar: bool) -> UserProfile {
    // ...
}
```

```typescript
// JavaScript uses camelCase
const profile = await invoke('get_user_profile', {
    userId: '123',
    includeAvatar: true
});
```

### Complex Arguments

Pass structured data using serde:

```rust
#[derive(Deserialize)]
struct CreateUserRequest {
    name: String,
    email: String,
    #[serde(default)]
    roles: Vec<String>,
}

#[tauri::command]
fn create_user(request: CreateUserRequest) -> Result<User, String> {
    // Entire struct is deserialized from JSON
}
```

```typescript
await invoke('create_user', {
    request: {
        name: 'Alice',
        email: 'alice@example.com',
        roles: ['admin', 'user']
    }
});
```

### Optional Arguments

Use `Option<T>` for optional parameters:

```rust
#[tauri::command]
fn search(
    query: String,
    limit: Option<usize>,
    offset: Option<usize>,
) -> Vec<Result> {
    let limit = limit.unwrap_or(10);
    let offset = offset.unwrap_or(0);
    // ...
}
```

```typescript
// All valid calls:
await invoke('search', { query: 'test' });
await invoke('search', { query: 'test', limit: 20 });
await invoke('search', { query: 'test', limit: 20, offset: 40 });
```

## Return Value Patterns

### Returning Complex Types

```rust
#[derive(Serialize)]
struct ApiResponse<T> {
    data: T,
    metadata: Metadata,
}

#[derive(Serialize)]
struct Metadata {
    total_count: usize,
    page: usize,
    per_page: usize,
}

#[tauri::command]
fn list_items(page: usize) -> ApiResponse<Vec<Item>> {
    ApiResponse {
        data: get_items(page),
        metadata: Metadata {
            total_count: 100,
            page,
            per_page: 10,
        },
    }
}
```

### Returning Enums

```rust
#[derive(Serialize)]
#[serde(tag = "type", content = "data")]
enum ProcessResult {
    Success { output: String },
    Partial { output: String, warnings: Vec<String> },
    Failed { error: String },
}

#[tauri::command]
fn process_file(path: String) -> ProcessResult {
    // Returns tagged union to frontend
}
```

```typescript
const result = await invoke('process_file', { path: '/tmp/file.txt' });
if (result.type === 'Success') {
    console.log(result.data.output);
} else if (result.type === 'Failed') {
    console.error(result.data.error);
}
```

## Async Command Patterns

### Spawning Background Tasks

```rust
use tokio::sync::mpsc;

#[tauri::command]
async fn start_background_job(app: AppHandle) -> Result<String, String> {
    let job_id = uuid::Uuid::new_v4().to_string();
    let job_id_clone = job_id.clone();

    tokio::spawn(async move {
        // Long-running work
        for i in 0..100 {
            tokio::time::sleep(Duration::from_millis(100)).await;
            app.emit(&format!("job-progress-{}", job_id_clone), i).ok();
        }
        app.emit(&format!("job-complete-{}", job_id_clone), ()).ok();
    });

    Ok(job_id)
}
```

### Cancellable Operations

```rust
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

struct JobState {
    cancelled: Arc<AtomicBool>,
}

#[tauri::command]
async fn start_cancellable_job(
    state: State<'_, Mutex<HashMap<String, JobState>>>
) -> Result<String, String> {
    let job_id = uuid::Uuid::new_v4().to_string();
    let cancelled = Arc::new(AtomicBool::new(false));

    state.lock().unwrap().insert(job_id.clone(), JobState {
        cancelled: cancelled.clone(),
    });

    tokio::spawn(async move {
        while !cancelled.load(Ordering::Relaxed) {
            // Do work in chunks, checking cancellation
        }
    });

    Ok(job_id)
}

#[tauri::command]
fn cancel_job(
    job_id: String,
    state: State<'_, Mutex<HashMap<String, JobState>>>
) -> Result<(), String> {
    if let Some(job) = state.lock().unwrap().get(&job_id) {
        job.cancelled.store(true, Ordering::Relaxed);
        Ok(())
    } else {
        Err("Job not found".to_string())
    }
}
```

### CPU-Intensive Operations

Use `spawn_blocking` for CPU-bound work to avoid blocking the async runtime:

```rust
#[tauri::command]
async fn compute_hash(data: Vec<u8>) -> Result<String, String> {
    tokio::task::spawn_blocking(move || {
        // CPU-intensive hashing
        let hash = sha256::digest(&data);
        hash
    })
    .await
    .map_err(|e| e.to_string())
}
```

## Error Handling Patterns

### Structured Error Responses

```rust
#[derive(Debug, Serialize)]
struct ErrorResponse {
    code: String,
    message: String,
    details: Option<serde_json::Value>,
}

#[derive(Debug, thiserror::Error)]
enum AppError {
    #[error("validation failed")]
    Validation(Vec<String>),
    #[error("not found: {0}")]
    NotFound(String),
    #[error("internal error")]
    Internal(#[from] anyhow::Error),
}

impl Serialize for AppError {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::ser::Serializer,
    {
        let response = match self {
            AppError::Validation(errors) => ErrorResponse {
                code: "VALIDATION_ERROR".to_string(),
                message: "Validation failed".to_string(),
                details: Some(serde_json::json!({ "errors": errors })),
            },
            AppError::NotFound(item) => ErrorResponse {
                code: "NOT_FOUND".to_string(),
                message: format!("{} not found", item),
                details: None,
            },
            AppError::Internal(e) => ErrorResponse {
                code: "INTERNAL_ERROR".to_string(),
                message: e.to_string(),
                details: None,
            },
        };
        response.serialize(serializer)
    }
}
```

### Error Recovery Patterns

```rust
#[tauri::command]
fn robust_operation() -> Result<Data, String> {
    // Try primary method
    match primary_method() {
        Ok(data) => return Ok(data),
        Err(e) => tracing::warn!("Primary method failed: {}", e),
    }

    // Fallback to secondary method
    match secondary_method() {
        Ok(data) => return Ok(data),
        Err(e) => tracing::warn!("Secondary method failed: {}", e),
    }

    // Return cached data as last resort
    get_cached_data().ok_or_else(|| "All methods failed".to_string())
}
```

## State Management Patterns

### Multiple State Types

```rust
struct DatabasePool(Pool<Postgres>);
struct ConfigState(Config);
struct CacheState(Mutex<LruCache<String, Data>>);

pub fn run() {
    tauri::Builder::default()
        .manage(DatabasePool(create_pool()))
        .manage(ConfigState(load_config()))
        .manage(CacheState(Mutex::new(LruCache::new(100))))
        .invoke_handler(tauri::generate_handler![...])
        .run(tauri::generate_context!())
        .unwrap();
}

#[tauri::command]
async fn query_with_cache(
    key: String,
    db: State<'_, DatabasePool>,
    cache: State<'_, CacheState>,
) -> Result<Data, String> {
    // Check cache first
    if let Some(data) = cache.0.lock().unwrap().get(&key) {
        return Ok(data.clone());
    }

    // Query database
    let data = sqlx::query_as("SELECT * FROM items WHERE key = $1")
        .bind(&key)
        .fetch_one(&db.0)
        .await
        .map_err(|e| e.to_string())?;

    // Update cache
    cache.0.lock().unwrap().put(key, data.clone());

    Ok(data)
}
```

### Using RwLock for Read-Heavy Workloads

```rust
use std::sync::RwLock;

struct AppState {
    // Use RwLock when reads >> writes
    config: RwLock<Config>,
    // Use Mutex for frequent writes
    sessions: Mutex<HashMap<String, Session>>,
}

#[tauri::command]
fn get_config(state: State<'_, AppState>) -> Config {
    state.config.read().unwrap().clone()
}

#[tauri::command]
fn update_config(state: State<'_, AppState>, new_config: Config) {
    *state.config.write().unwrap() = new_config;
}
```

## Window and Multi-Window Patterns

### Window-Specific Commands

```rust
#[tauri::command]
fn close_current_window(window: tauri::WebviewWindow) -> Result<(), String> {
    window.close().map_err(|e| e.to_string())
}

#[tauri::command]
fn minimize_to_tray(window: tauri::WebviewWindow) -> Result<(), String> {
    window.hide().map_err(|e| e.to_string())
}
```

### Creating New Windows

```rust
#[tauri::command]
async fn open_settings_window(app: AppHandle) -> Result<(), String> {
    tauri::WebviewWindowBuilder::new(
        &app,
        "settings",
        tauri::WebviewUrl::App("settings.html".into())
    )
    .title("Settings")
    .inner_size(600.0, 400.0)
    .resizable(false)
    .build()
    .map_err(|e| e.to_string())?;

    Ok(())
}
```

### Cross-Window Communication

```rust
#[tauri::command]
fn broadcast_to_all_windows(app: AppHandle, message: String) -> Result<(), String> {
    app.emit("broadcast", message).map_err(|e| e.to_string())
}

#[tauri::command]
fn send_to_window(
    app: AppHandle,
    window_label: String,
    message: String
) -> Result<(), String> {
    if let Some(window) = app.get_webview_window(&window_label) {
        window.emit("message", message).map_err(|e| e.to_string())
    } else {
        Err(format!("Window '{}' not found", window_label))
    }
}
```

## File System Patterns

### Safe Path Handling

```rust
use std::path::PathBuf;

#[tauri::command]
fn read_app_file(
    app: AppHandle,
    relative_path: String
) -> Result<String, String> {
    let app_dir = app.path().app_data_dir().map_err(|e| e.to_string())?;

    // Sanitize path to prevent directory traversal
    let requested = PathBuf::from(&relative_path);
    if requested.components().any(|c| matches!(c, std::path::Component::ParentDir)) {
        return Err("Invalid path: parent directory access not allowed".to_string());
    }

    let full_path = app_dir.join(requested);

    // Verify path is still within app directory
    if !full_path.starts_with(&app_dir) {
        return Err("Invalid path: outside app directory".to_string());
    }

    std::fs::read_to_string(full_path).map_err(|e| e.to_string())
}
```

### File Dialog Integration

```rust
use tauri_plugin_dialog::DialogExt;

#[tauri::command]
async fn select_file(app: AppHandle) -> Result<Option<String>, String> {
    let file = app
        .dialog()
        .file()
        .add_filter("Images", &["png", "jpg", "jpeg"])
        .pick_file()
        .await;

    Ok(file.map(|f| f.to_string_lossy().to_string()))
}
```

## Testing Commands

### Unit Testing

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_greet() {
        let result = greet("World");
        assert_eq!(result, "Hello, World!");
    }

    #[tokio::test]
    async fn test_async_command() {
        let result = fetch_data("https://api.example.com".to_string()).await;
        assert!(result.is_ok());
    }
}
```

### Integration Testing with Tauri

```rust
#[cfg(test)]
mod integration_tests {
    use tauri::test::{mock_builder, MockRuntime};

    fn create_app() -> tauri::App<MockRuntime> {
        mock_builder()
            .invoke_handler(tauri::generate_handler![greet])
            .build(tauri::generate_context!())
            .unwrap()
    }

    #[test]
    fn test_command_registration() {
        let app = create_app();
        // Test that commands are properly registered
    }
}
```

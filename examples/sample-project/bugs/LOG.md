# Bug Log

## BUG-001: SQLite path not created on first run

- **Description:** `taskflow add` fails with FileNotFoundError if `~/.taskflow/` doesn't exist
- **Location:** `src/taskflow/repository.py:15`
- **Phase found:** 7-test (post-implementation testing)
- **Severity:** blocking
- **Expected:** Directory created automatically on first use
- **Actual:** FileNotFoundError raised
- **Status:** fixed (T-1 updated to create directory)
- **Fix:** Added `Path(db_path).parent.mkdir(parents=True, exist_ok=True)` before connection

# 品牌重命名计划：Simple Live -> StitchTV (已完成)

将项目中所有 `Simple Live` 相关的标识符（代码、文件名、路径）重命名为 `StitchTV`。

## 任务完成情况

### 1. 内容替换 (Content Replacement)
- [x] 批量替换格式：
    - `simple_live` -> `stitchtv`
    - `simple-live` -> `stitchtv`
    - `Simple Live` -> `StitchTV`
    - `SimpleLive` -> `StitchTV`
    - `simpleLive` -> `stitchTv`
    - `SIMPLE_LIVE` -> `STITCHTV`
    - `simplelive` -> `stitchtv`
- [x] 覆盖范围：所有源码、配置文件、`.github` 工作流。

### 2. 文件名重命名 (File Renaming)
- [x] 查找并重命名了所有包含 `simple_live` 等标识符的文件。

### 3. 目录名重命名 (Directory Renaming)
- [x] 核心目录重命名：
    - `simple_live_core` -> `stitchtv_core`
    - `simple_live_console` -> `stitchtv_console`
    - `simple_live_tv_app` -> `stitchtv_tv_app`
    - `simple_live_app` -> `stitchtv_app`
- [x] Android 包路径及源码路径重命名。

## 验证结论
- [x] `grep` 验证：源码中已无 `simple_live` 相关字符串（排除 `build/` 目录）。
- [x] `find` 验证：路径中已无 `simple_live` 相关命名。

**注：项目根目录 `/Users/alien/Documents/codes/simple_live` 建议由用户手动重命名为 `stitchtv` 以避免当前会话路径失效。**

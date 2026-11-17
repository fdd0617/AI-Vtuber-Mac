# macOS 使用说明

## 支持范围

macOS 可以运行 Python 主程序、NiceGUI 管理后台、Live2D 网页、字幕、点歌逻辑和云端模型/TTS。抖音弹幕可尝试项目内置的「抖音2」网页 WebSocket 监听器，不需要 Windows 的 `WssBarrageServer.exe`；抖音网页协议可能变化，能否连接取决于当前平台接口。抖音直播伴侣没有 macOS 版时，需使用 Mac 可用的 OBS 推流/虚拟摄像头方案。

口型峰值读取使用 BlackHole 等虚拟音频输入设备。按键唤醒语音聊天、Windows 串口/窗口控制和 Windows 直播伴侣不属于 macOS 支持范围。

## 安装

需要 macOS、Python 3.10 至 3.12、Xcode Command Line Tools、Homebrew。先安装 PortAudio：

```bash
xcode-select --install
brew install portaudio
```

在仓库根目录运行：

```bash
chmod +x setup-macos.sh start-macos.sh start-macos-stage-services.sh stop-macos-stage-services.sh
./setup-macos.sh
```

若有多个 Python，可用 `PYTHON=python3.12 ./setup-macos.sh` 指定解释器。首次安装后，按原项目说明配置模型 API Key、Fish Audio Key 和 Live2D 模型。

## 启动

```bash
./start-macos.sh
```

管理后台默认在 <http://127.0.0.1:8081>。在「直播接入」里选择「抖音2」，`room_display_id` 填抖音直播间号。保存后从「操作」启动主程序。OBS 浏览器来源使用：

- 竖屏：`http://127.0.0.1:12345/Live2D/stage-portrait.html`，1080 × 1920
- 横屏：`http://127.0.0.1:12345/Live2D/stage-landscape.html`，1920 × 1080

字幕、口型和舞台状态服务由启动脚本一起运行；停止它们可运行 `./stop-macos-stage-services.sh`。查看日志：`out/songroom/*.stderr.txt`。

## 口型音频设备

安装 BlackHole 2ch 后，在 macOS「音频 MIDI 设置」中建立多输出设备，把实际扬声器和 BlackHole 都加入，然后把系统输出切换到该多输出设备。启动脚本会查找名称含 `BlackHole` 的输入设备。如果设备名称不同，可设置 `DAFEIYU_AUDIO_MONITOR_DEVICE` 为设备名关键词或输入设备序号后重新启动。

音频权限和设备由 macOS 管理。口型监测只读取所选虚拟输入的音量峰值；没有找到 BlackHole 时主程序和字幕仍可运行，但不会有音量驱动的嘴型。

## 抖音监听限制

「抖音2」是仓库自带的网页协议实现，不是官方 API。登录/协议变化可能导致连接失败。若当前账号或地区无法使用，可让另一台 Windows 电脑运行原弹幕监听器，并配置本项目的 `dy` 平台通过本机 WebSocket 接收事件；两台设备需在同一局域网，且须调整监听地址与防火墙规则。

运行 `./.venv/bin/python tools/check_setup.py` 可检查配置和本机服务。联网自检 `--online` 会实际调用大模型与语音服务。

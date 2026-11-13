# Zhuoyu Biped Tools

基于 Lorne Brooks 的 **Biped Helper + Picker 3.5** 二次开发。给 3ds Max 动画师用的 Biped 选择器。常用的身体部件、道具和配件都可以从按钮选中，角色换了也可以自己改绑定。

## 下载和安装

1. 从 [GitHub Release](https://github.com/Elviszhuoyu/Zhuoyu-Biped-Tools/releases/tag/v1.9.9) 下载 **Zhuoyu_BipedTools_1.9.9.mzp**。
2. 在 Windows 资源管理器里将整个 MZP 拖进 **3ds Max 的视口**。文件可以直接拖入，Windows 端无需解压或运行构建命令。
3. 打开含 Biped 的场景。在 **Zhuoyu Biped** 宏分类运行选择器。安装时如果场景已经有 Biped，选择器会直接打开。标题显示 **本地 1.9.9**。

也可以通过 **Scripting → Run Script（脚本 → 运行脚本）** 打开同一个 MZP。旧版工程建议先另存副本再升级。

## 上手

- **选身体部件。** 先选当前 Biped，再点身体色块、手指或全身按钮。Shift/Ctrl 加选，Alt 减选，也可沿父子层级继续选。
- **自己加按钮。** 打开「＋自定义按钮」，新建一组，选中一个或多个道具、配件或辅助节点，再点「使用视口所选（多个）」。分组可以改名、拖动和跨页排序。悬停能查到绑定目标、已选数量和失效数量。
- **修正内置色块。** 先在视口选好节点，再右键单击或左键双击色块。点「载入视口选择」，核对后应用。也可以恢复自动识别。保存 `.max` 后，每个角色的映射随场景保留。
- **继续做动画。** 折叠区保留原有关键帧、IK、姿势、残影和轨迹等工具。补键可明确选当前帧或按范围执行。

插件顶部的「使用指南」可打开 [离线手册](BipedTools/src/Guide.html)。旧工程在 1.9.8 起自动迁移选择记录，保留有效的自定义组、顺序和绑定，并解除旧选择记录可能造成的 Link／Unlink 循环依赖。

## 兼容性和构建

安装包在 3ds Max 2020 上验证。其他年份请结合自己的 Max 版本和角色场景试用。

开发者可运行 `powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\Build-Mzp.ps1` 生成 `dist/Zhuoyu_BipedTools_1.9.9.mzp`。构建需要 Windows 自带的 .NET Framework 4.x 编译器和支持 `net8.0-windows` 的 .NET SDK。

## 来源

原脚本为 Lorne Brooks 的 [Biped Helper + Picker 3.5](https://www.scriptspot.com/3ds-max/scripts/biped-helper-picker)。其源码第 118 行允许修改和分发脚本。中英文脚本均保留原作者署名和声明。1.9.9 的工具图标为本项目制作，轨迹辅助点使用 [Autodesk 的 MAXScript 表面拾取接口](https://help.autodesk.com/cloudhelp/2019/ENU/3DSMax-MAXScript/files/GUID-0A4CD125-5CA0-42DA-B2D6-B8FDF511CCE8.htm) 实现。

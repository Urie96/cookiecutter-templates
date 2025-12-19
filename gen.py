import os
import json
from pathlib import Path


def symlink_template(folder: Path):
    link_path = folder / "templates"
    target_path = Path("../templates")

    try:
        if link_path.exists():
            return

        link_path.symlink_to(target_path)
        print(f"创建软链接: {link_path} -> {target_path}")

    except Exception as e:
        print(f"错误: 无法为 {folder.name} 创建软链接: {e}")


def main():
    # 获取当前目录下的所有文件夹
    current_dir = Path.cwd()

    folders = [
        d
        for d in current_dir.iterdir()
        if d.is_dir() and not d.name.startswith(".") and d.name != "templates"
    ]

    if len(folders) == 0:
        print("当前目录中没有文件夹")
        return

    for folder in folders:
        symlink_template(folder)

    # 构建数据结构
    data = {
        "templates": {
            folder.name: {"path": f"./{folder.name}/"} for folder in sorted(folders)
        }
    }

    # 写入文件
    with open("cookiecutter.json", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print("JSON 文件已生成: templates.json")
    print("\n文件内容：")
    print(json.dumps(data, indent=2, ensure_ascii=False))

    # for folder in folders:


if __name__ == "__main__":
    main()

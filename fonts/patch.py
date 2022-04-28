import argparse
import pathlib
import hashlib
import os
import requests

dir_path = os.path.dirname(os.path.realpath(__file__))
work_dir = pathlib.Path(dir_path) / "patch"


class Info:
    def __init__(self, url, path, dir, md5):
        self.url: str = url
        self.path: pathlib.Path = path
        self.zip_path = self.path.parent / self.path.name.replace(".zip", "")
        self.font_dir = self.zip_path / dir
        self.out_linux_dir = self.zip_path / "out" / "Linux"
        self.out_win_dir = self.zip_path / "out" / "Windows"

        self.md5: str = md5
        self.need_dl = True

    def set_proxy(self):
        print("Setting proxy {}".format(self.url))
        gh_proxy = "https://ghproxy.com/"
        self.url = gh_proxy + self.url
        print("           to {}".format(self.url))

    def check_md(self):
        if self.path.exists():
            with self.path.open("rb") as f:
                md5 = hashlib.md5(f.read()).hexdigest()
                if md5 == self.md5:
                    print("MD5 matched! Skipping download.")
                    self.need_dl = False
                else:
                    print(
                        "MD5 dismatch: \n\twant: {}\n\treal: {}".format(self.md5, md5)
                    )

    def download(self):
        self.check_md()
        if self.need_dl:
            print("Downloading {}".format(self.url))
            self.path.parent.mkdir(parents=True, exist_ok=True)
            with self.path.open("wb") as f:
                f.write(requests.get(self.url).content)
        os.system("unzip -u -d {} {}".format(self.zip_path, self.path))

    def patch(self):
        # docker run --rm -v ~/SF-Mono-Font:/in -v ~/SF-Mono-Font-Out:/out nerdfonts/patcher -c -w -s
        self.out_linux_dir.mkdir(parents=True, exist_ok=True)
        cmd = f"docker run --rm -v {self.font_dir}:/in -v {self.out_linux_dir}:/out nerdfonts/patcher -c -s"
        print(cmd)
        os.system(cmd)
        self.out_win_dir.mkdir(parents=True, exist_ok=True)
        cmd = f"docker run --rm -v {self.font_dir}:/in -v {self.out_win_dir}:/out nerdfonts/patcher -c -w -s"
        print(cmd)
        os.system(cmd)


font_infos = {
    "FiraCode": Info(
        "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip",
        work_dir / "FiraCode.zip",
        "ttf",
        "77dfd6d902db1ee8d8a6722373ce7933",
    ),
    "SFMono": Info(
        "https://github.com/czccc/SF-Mono-Font/archive/refs/tags/1.0.zip",
        work_dir / "SFMono.zip",
        "SF-Mono-Font-1.0",
        "b8548aa44fbc8bca0b93f6118ac0e025",
    ),
    "Hack": Info(
        "https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip",
        work_dir / "Hack.zip",
        "ttf",
        "03d165f618b060c7e34268c8dd7ebaee",
    ),
    "Jet": Info(
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip",
        work_dir / "Jet.zip",
        "fonts/ttf",
        "ce7fe9233700251c34e409dc85ef91d4",
    ),
}


def parser():
    args = argparse.ArgumentParser()
    args.add_argument("name", choices=font_infos.keys())
    args.add_argument("--proxy", type=bool, default=True)
    args = args.parse_args()
    info = font_infos[args.name]
    if args.proxy:
        info.set_proxy()
    return info


def main():
    info = parser()
    info.download()
    info.patch()


if __name__ == "__main__":
    main()

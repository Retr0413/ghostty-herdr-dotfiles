# Ghostty + Herdr dotfiles

macOS 向けの Ghostty と Herdr の設定です。Ghostty の最初のターミナルで Herdr を起動し、現在使っている配色、キーバインド、Herdr の端末・セッション設定を再現します。

## 新しい Mac への導入

Homebrew と Git を用意してから、次を実行します。

```sh
git clone https://github.com/Retr0413/ghostty-herdr-dotfiles.git
cd ghostty-herdr-dotfiles
brew bundle --file=Brewfile
./install.sh
```

Ghostty を再起動してください。`install.sh` は設定をシンボリックリンクで配置します。既存ファイルがあれば、同じディレクトリに `.backup.日時` を付けて退避します。再実行してもリンク済みの設定は変更しません。

## 設定の配置先

| リポジトリ | macOS の配置先 |
| --- | --- |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `herdr/focus-last-tab.sh` | `~/.local/bin/herdr-focus-last-tab` |

Ghostty からは `~/.local/bin/herdr` を起動します。`install.sh` はその場所に Herdr がなければ、インストール済みの `herdr` へのリンクを作ります。Herdr の設定を変えた場合は `herdr server reload-config` で再読み込みできます。

Herdr のセッション、ログ、ソケット、リリース情報は端末固有の実行データなので管理しません。設定に書かれた `claude` / `codex` との連携を使う場合、それらの CLI は各 Mac に別途導入してください。

## ターミナル内のタブ操作

Ghostty のタブではなく Herdr のタブを操作します。Ghostty 側は Herdr の Ctrl+B プレフィックスを送るだけで、実際の切り替えは Herdr が行います。

| キー | 動作 | 送出 |
| --- | --- | --- |
| `Cmd+1`〜`Cmd+8` | その番号のタブへ移動 | `Ctrl+B` + 数字 |
| `Cmd+9` | 最後のタブへ移動（macOS の慣習） | `Ctrl+B` + `0` |
| `Cmd+T` | タブを追加 | `Ctrl+B` `c` |
| `Cmd+Shift+W` | タブを閉じる | `Ctrl+B` `X` |

`Ctrl+B` に続けて `9` を押した場合は、9番目のタブへ移動します（Herdr の `switch_tab`）。

`Cmd+9` は Herdr に「最後のタブ」機能が無いため、`herdr tab list` と `herdr tab focus` を使う `focus-last-tab.sh` を経由します。Ghostty の設定を変更したときは `Cmd+Shift+,` で再読み込み、Herdr の設定は `herdr server reload-config` で反映します。

## この環境で確認したバージョン

- Ghostty 1.3.1
- Herdr 0.8.0

Homebrew は導入時に利用可能な版を入れるため、上記の版に固定はしていません。

## 参照

- [Ghostty の設定ファイル](https://ghostty.org/docs/config)
- [Ghostty の `initial-command`](https://ghostty.org/docs/config/reference)
- [Herdr の設定](https://herdr.dev/docs/configuration/)
- [Herdr の導入](https://herdr.dev/docs/install/)

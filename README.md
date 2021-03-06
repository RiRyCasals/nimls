# nimls
Nim言語によって実装されたlsコマンド．

## 使い方

```zsh
$ nimls [option]... [path]...
```

`nimls` のみ入力した場合は以下と同等．

```zsh
$ nimls ./
```

## コマンドオプション
大きく分けて3種類存在する．

| 種類 | 内容 |
| ---- | ---- |
| メタ | nimlsに関する情報を提供 |
| フィルタリング | 取得するファイルやディレクトリに制限をかける |
| ディスプレイ | 表示される項目を変更する |

### メタオプション
ショートオプションは特殊記号で表現

| ショート | ロング | 機能 |
| ---- | ---- | ---- |
| -? | -\-help | ドキュメントを表示 |
| -! | -\-version | バージョンを表示 |

### フィルタリングオプション
ショートオプションは大文字で表現．

| ショート | ロング | 機能 |
| ---- | ---- | ---- |
| -A | -\-all | 隠しファイル，隠しディレクトリを含めて取得する |
| -D | -\-dir | ディレクトリのみを取得する |
| -F | -\-file | ファイルのみを取得する |

### ディスプレイオプション
ショートオプションは小文字で表現．

| ショート | ロング | 機能 |
| ---- | ---- | ---- |
| -i | -\-info | 詳細情報を表示する |
| -p | -\-permission | 権限を表示する |
| -r | -\-recurse | ファイル，ディレクトリを再帰的に取得する |
| -s | -\-size | ファイルサイズを表示する |
| -t | -\-time | 作成日時，更新日時を表示する |

`-i`は`-p, -s, -t`を含み，追加の情報を付与する．

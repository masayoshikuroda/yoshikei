# yoshikei

ヨシケイのメニューをOnlineで取得します。

# 事前準備

ruby
- selenium-webdriver

# 利用例

## カットミールのメニュー

今日のメニューを取得

```
$ ruby cutmeal_menu.rb | jq
{
  "date-at-num": "6/27",
  "date-at-week": "(月)",
  "title-name": "＜パパッと10分牛丼セット＞牛丼",
  "kind": "カットミール",
  "date": "6/27(月)",
  "info": "6/27(月)のお届けです。",
  "name": "＜パパッと10分牛丼セット＞牛丼"
}
$
```

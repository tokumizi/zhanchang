#!/bin/bash
# 战场 · 一键部署到 GitHub Pages
CLIENT=178c6fc778ccc68e1d6a
APPDIR="/Users/wangziyi/ink-animation/zhanchang-app"

echo "正在获取 GitHub 登录码…"
resp=$(curl -s https://github.com/login/device/code -H "Accept: application/json" -d "client_id=$CLIENT&scope=repo")
UC=$(echo "$resp" | python3 -c "import sys,json;print(json.load(sys.stdin)['user_code'])")
DC=$(echo "$resp" | python3 -c "import sys,json;print(json.load(sys.stdin)['device_code'])")

echo ""
echo "=================================================="
echo "  浏览器即将自动打开授权页，请这样做："
echo ""
echo "   1) 输入这个码:   $UC"
echo "   2) 点 Continue"
echo "   3) 点绿色按钮 Authorize GitHub CLI"
echo "   4) 看到 Congratulations 即可，回到这里等待"
echo "=================================================="
echo ""
sleep 2
open "https://github.com/login/device"

echo "等待授权中（授权后自动继续）…"
TOKEN=""
while true; do
  r=$(curl -s https://github.com/login/oauth/access_token -H "Accept: application/json" \
      -d "client_id=$CLIENT&device_code=$DC&grant_type=urn:ietf:params:oauth:grant-type:device_code")
  TOKEN=$(echo "$r" | python3 -c "import sys,json;print(json.load(sys.stdin).get('access_token',''))" 2>/dev/null)
  [ -n "$TOKEN" ] && break
  e=$(echo "$r" | python3 -c "import sys,json;print(json.load(sys.stdin).get('error',''))" 2>/dev/null)
  [ "$e" = "expired_token" ] && { echo "登录码过期，请重新运行本脚本"; exit 1; }
  [ "$e" = "access_denied" ] && { echo "你拒绝了授权，已退出"; exit 1; }
  sleep 6
done

echo "✅ 授权成功，开始部署…"
OWNER=$(curl -s -H "Authorization: Bearer $TOKEN" https://api.github.com/user | python3 -c "import sys,json;print(json.load(sys.stdin)['login'])")
echo "GitHub 账号: $OWNER"

curl -s -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos -d '{"name":"zhanchang","private":false,"description":"战场 · 每日指挥台"}' \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print('仓库:',d.get('full_name') or d.get('message'))"

cd "$APPDIR" || exit 1
git branch -M main
git add -A
git commit -m "update $(date +%Y-%m-%d_%H:%M)" 2>/dev/null
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$OWNER/zhanchang.git"
echo "推送文件…"
git push "https://x-access-token:$TOKEN@github.com/$OWNER/zhanchang.git" main 2>&1 | tail -2

sleep 2
echo "开启 Pages…"
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$OWNER/zhanchang/pages" -d '{"source":{"branch":"main","path":"/"}}' \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print('Pages:',d.get('html_url') or d.get('message'))"

echo ""
echo "=================================================="
echo "✅ 完成！你的 App 网址："
echo "   https://$OWNER.github.io/zhanchang/"
echo ""
echo "  首次 1-3 分钟生效，404 属正常，刷新几次即出。"
echo "  手机 Safari 打开该网址 → 分享 → 添加到主屏幕"
echo "=================================================="

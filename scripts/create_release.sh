#!/bin/bash

# バージョン番号を取得
VERSION=$(cat version.txt)

# タグを作成
git tag -a "v$VERSION" -m "Release version $VERSION"

# タグをプッシュ
git push origin "v$VERSION"

echo "Created and pushed tag v$VERSION"
echo "GitHub Actions will now build and create a release" 
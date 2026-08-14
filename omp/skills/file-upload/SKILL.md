---
name: file-upload
description: Upload a file when Ryan asks, or when a permanent public URL is needed for a pull request description. Use the private files-stoffel-org.vercel.app uploader and return the URL from the response body.
metadata:
  harness: [omp, claude, codex]
  platform: [darwin, linux, macos]
  requires: "curl; FILE_HOST_TOKEN or ~/.config/files.stoffel.org/upload-token; ffmpeg only for optional GIF previews"
---

# File upload

Upload files to `https://files-stoffel-org.vercel.app` and return the permanent public URL from the response body. Authenticate with `FILE_HOST_TOKEN`, falling back to `~/.config/files.stoffel.org/upload-token`. If neither is available, tell Ryan instead of guessing or attempting an anonymous upload.

Treat every uploaded file and returned URL as public and permanent. Never upload secrets, credentials, private URLs, private logs, or unrelated files. Never print or otherwise expose the upload token.

## Upload

Use the file's basename as `<filename>`, such as `login-flow.mp4`. Do not include local directory components. The server slugifies the name and adds a random suffix, so names do not need to be unique.

The current Vercel endpoint accepts files smaller than 4,000,000 bytes. Check the size before uploading. If a file is too large, tell Ryan rather than compressing, truncating, or uploading it elsewhere without permission.

```bash
token="${FILE_HOST_TOKEN:-}"
if [ -z "$token" ] && [ -r "$HOME/.config/files.stoffel.org/upload-token" ]; then
  IFS= read -r token < "$HOME/.config/files.stoffel.org/upload-token"
fi
if [ -z "$token" ]; then
  printf 'File upload token is not configured\n' >&2
  exit 1
fi

file="<path-to-file>"
filename="$(basename -- "$file")"

curl --silent --show-error --fail-with-body \
  --request PUT \
  --upload-file "$file" \
  --header "X-Upload-Token: ${token}" \
  "https://files-stoffel-org.vercel.app/${filename}"
```

Use the response body exactly as the public URL. Do not construct a URL from the requested filename. Report both the local path and returned URL. If the request fails, report the actual HTTP or network error without exposing the token.

## Use the URL in GitHub

- Embed images (`png`, `jpg`, `jpeg`, `gif`, `webp`) as `![description](URL)`.
- Link videos (`mp4`, `mov`, `webm`) as `[screen recording](URL)` because GitHub does not inline-play externally hosted video.
- When an inline preview genuinely helps and the clip is shorter than about 30 seconds, also create and upload a GIF preview:

```bash
ffmpeg -i recording.mp4 -vf "fps=10,scale=800:-1:flags=lanczos" -loop 0 preview.gif
```

Embed the GIF and link the full-quality video below it. Keep alt text and link labels descriptive. If `ffmpeg` is unavailable, report that limitation and still link the original video rather than installing unrelated software silently.

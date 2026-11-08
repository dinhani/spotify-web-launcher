set windows-shell := ["pwsh.exe", "-NoLogo", "-NoProfile", "-Command"]

export UV_PROJECT_ENVIRONMENT := data_local_directory() / "_dev" / "uv" / "envs" / "spotify-web-launcher"

[doc("List tasks")]
[group("project")]
default:
    @just --list --unsorted

[doc("Install dependencies")]
[group("project")]
setup:
    uv sync

[doc("List line counts")]
[group("project/report")]
cloc:
    cloc src

[doc("Render page")]
[group("run")]
render:
    uv run src/artists-render.py
    Start-Process Z:/apps/web/spotify-web-launcher.html
alias run := render

[doc("Download all datasources")]
[group("data")]
update: spotify-download lastfm-download export

[doc("Download Spotify artists")]
[group("data")]
spotify-download *args:
    uv run src/artists-download.py {{args}}
alias sd := spotify-download

[doc("Import Spotify history")]
[group("data")]
spotify-import *export_dir:
    uv run src/spotify-history.py {{export_dir}}

[doc("Download Last.fm history")]
[group("data")]
lastfm-download:
    uv run src/lastfm-history.py

[doc("Compare Last.fm artists with Spotify artists")]
[group("data")]
lastfm-compare:
    uv run src/artists-lastfm.py

[doc("Export artists to TSV")]
[group("data")]
export:
    uv run src/artists-export.py

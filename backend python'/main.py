from flask import Flask, request, jsonify, send_from_directory
import yt_dlp
import os
import re
import traceback

app = Flask(__name__)
DOWNLOAD_DIR = os.path.join(os.getcwd(), 'downloads')

def clean_filename(s):
    return re.sub(r'[\\/*?:"<>|：｜]', "_", s)

@app.route('/download', methods=['POST'])
def download_video():
    data = request.json
    url = data.get('url')

    ydl_opts = {
        'outtmpl': os.path.join(DOWNLOAD_DIR, '%(title)s.%(ext)s'),
        'format': 'best[ext=mp4][vcodec^=avc1][acodec^=mp4a]/best',
        'merge_output_format': 'mp4',
        'noplaylist': True,
        'quiet': False,
        'socket_timeout': 120,
        'postprocessors': [{
            'key': 'FFmpegVideoConvertor',
            'preferedformat': 'mp4',
        }]
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)

            actual_path = ydl.prepare_filename(info)
            if not os.path.exists(actual_path):
                return jsonify({"status": "error", "message": "Downloaded file not found."}), 500

            raw_title = info.get('title', 'video')
            clean_name = clean_filename(raw_title) + ".mp4"
            clean_path = os.path.join(DOWNLOAD_DIR, clean_name)

            if actual_path != clean_path:
                os.rename(actual_path, clean_path)

            return jsonify({
                "status": "success",
                "message": "Video downloaded and ready!",
                "file": clean_name,
                "url": f"http://{request.host}/GTGrabber/{clean_name}"
            })

    except Exception as e:
        traceback.print_exc()
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/GTGrabber/<filename>')
def serve_video(filename):
    try:
        return send_from_directory(DOWNLOAD_DIR, filename, as_attachment=True)  # <--- Force download
    except FileNotFoundError:
        return jsonify({"status": "error", "message": "File not found"}), 404

if __name__ == '__main__':
    os.makedirs(DOWNLOAD_DIR, exist_ok=True)
    app.run(host='0.0.0.0', port=5000)

import os
from mutagen.mp3 import MP3
from datetime import timedelta

# Path to your folder containing MP3 files
folder_path = "."

# Path to output text file
output_file = "mp3_durations.txt"

def format_duration(seconds):
    """Convert seconds to H:mm:ss or mm:ss format (omit hours if < 1 hour)."""
    td = timedelta(seconds=int(seconds))
    total_seconds = int(td.total_seconds())
    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    if hours > 0:
        return f"{hours}:{minutes:02}:{seconds:02}"
    else:
        return f"{minutes}:{seconds:02}"

with open(output_file, "w", encoding="utf-8") as f:
    for file_name in os.listdir(folder_path):
        if file_name.lower().endswith(".mp3"):
            file_path = os.path.join(folder_path, file_name)
            audio = MP3(file_path)
            duration = audio.info.length
            formatted_duration = format_duration(duration)
            #line = f'{{"dur": "{formatted_duration}"}},\n'
            line = f'{{"tit": "{file_name}", "dur": "{formatted_duration}"}},\n'
            f.write(line)
            print(line.strip())

print(f"\nAll durations saved to: {output_file}")

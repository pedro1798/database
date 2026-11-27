cd ~/workplace/database/phase4
git switch main
python3 -m venv venv         # 이미 만들었으면 생략
source venv/bin/activate
pip install -r requirements.txt
flask --app app run

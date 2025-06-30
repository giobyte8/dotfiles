import os
import requests
import sys
from dotenv import load_dotenv


load_dotenv()


# Parse title and content from command line arguments
if len(sys.argv) < 3:
    raise Exception('Notif title and content are required')
notif_title = str(sys.argv[1])
notif_content = str(sys.argv[2])

# Central API
__CT_API_URL = os.getenv('CT_API_URL')
__CT_API_KEY = os.getenv('CT_API_KEY')
if not __CT_API_URL or not __CT_API_KEY:
    raise Exception('Central API URL or API Key is not set')


def post_notification(title: str, content: str):
    headers = {
        'Authorization': f'Bearer {__CT_API_KEY}',
        'Content-Type': 'application/json'
    }

    payload = {
        'title': title,
        'content': content
    }

    response = requests.post(
        f'{__CT_API_URL}',
        json=payload,
        headers=headers
    )

    if response.status_code != 201:
        raise Exception(f'Failed to post notification: {response.text}')


post_notification(notif_title, notif_content)


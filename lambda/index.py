import urllib.parse

def handler(event, context):
    # Retrieve filename from the S3 Event Notification schema
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    print(f"Image received: {key}")
    return {
        'statusCode': 200,
        'body': f"Successfully processed asset {key}"
    }

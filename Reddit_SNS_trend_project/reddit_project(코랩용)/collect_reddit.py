import requests
import pandas as pd
from datetime import datetime
import time

def collect_reddit_json(subreddit="technology", category="hot", limit=100):
    url = f"https://www.reddit.com/r/{subreddit}/{category}.json?limit={limit}"

    headers = {
        "User-Agent": "reddit-trend-analysis-project/1.0 by u_Lost_Big2317"
    }

    response = requests.get(url, headers=headers)

    print(f"r/{subreddit} - {category} 상태코드:", response.status_code)

    if response.status_code != 200:
        print(response.text[:300])
        return pd.DataFrame()

    data = response.json()
    posts = []

    for item in data["data"]["children"]:
        post = item["data"]

        posts.append({
            "post_id": post.get("id"),
            "subreddit": subreddit,
            "category": category,
            "title": post.get("title"),
            "body": post.get("selftext"),
            "score": post.get("score"),
            "upvote_ratio": post.get("upvote_ratio"),
            "num_comments": post.get("num_comments"),
            "created_utc": datetime.fromtimestamp(post.get("created_utc")),
            "url": "https://www.reddit.com" + post.get("permalink")
        })

    df = pd.DataFrame(posts)
    print(f"r/{subreddit} - {category} 수집 완료: {len(df)}개")

    return df


subreddits = [
    "technology",
    "MachineLearning",
    "artificial",
    "Futurology",
    "ChatGPT",
    "datascience",
    "programming",
    "AI",
    "computers",
    "gadgets"
]

categories = ["hot", "new", "top"]

all_data = []

for sub in subreddits:
    for cat in categories:
        df = collect_reddit_json(subreddit=sub, category=cat, limit=100)
        all_data.append(df)
        time.sleep(2)

reddit_df = pd.concat(all_data, ignore_index=True)

reddit_df["title"] = reddit_df["title"].fillna("")
reddit_df["body"] = reddit_df["body"].fillna("")
reddit_df["text"] = reddit_df["title"] + " " + reddit_df["body"]

#중복 데이터 제거
reddit_df = reddit_df.drop_duplicates(subset=["post_id"])
#빈 텍스트 제거
reddit_df = reddit_df[reddit_df["text"].str.strip() != ""]

#CSV 파일로 저장
reddit_df.to_csv("reddit_trend_data.csv", index=False, encoding="utf-8-sig")

print("\n최종 데이터 개수:", len(reddit_df))
print("CSV 저장!")
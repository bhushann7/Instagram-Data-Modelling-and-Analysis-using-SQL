-- Updating the caption of a specific post

UPDATE post
SET post_caption = 'Best Pizza ever'
WHERE post_id = 3;


-- Selecting all posts for a particuar user

SELECT *
FROM post
WHERE user_id = 1;


-- Selecting all the posts and ordering them by date_posted in descending order

SELECT *
FROM post
ORDER BY date_posted DESC;


-- Counting the number of likes for each post and showing only the posts with more than 2 likes

-- Approach 1 
SELECT post_id,COUNT(like_id)
FROM likes
GROUP BY post_id
HAVING COUNT(like_id) > 2


-- Approach 2
SELECT p.post_id, COUNT(l.like_id)
FROM post p
JOIN likes l
ON p.post_id = l.post_id
GROUP BY p.post_id
HAVING COUNT(l.like_id) > 2


-- Finding the total number of likes for all posts

-- Approach 1 with CTE
	
WITH total_likes_cte AS (
	SELECT p.post_id AS post_id,COUNT(l.like_id) AS total_likes_per_post
	FROM post p
	LEFT JOIN likes l
	ON p.post_id = l.post_id
	GROUP BY p.post_id
)

SELECT SUM(total_likes_per_post) AS total_likes
FROM total_likes_cte

-- Approach 2 with SubQuery

SELECT SUM(total_likes_per_post) AS total_likes
FROM (
	SELECT p.post_id AS post_id,COUNT(l.like_id) AS total_likes_per_post
	FROM post p
	LEFT JOIN likes l
	ON p.post_id = l.post_id
	GROUP BY p.post_id) AS total_likes_subq


-- Finding all the users who have commented on post_id 1

SELECT user_name 
FROM users
WHERE user_id IN (
	SELECT c.user_id
	FROM comment c
	WHERE post_id = 1)


-- Ranking the posts based on the number of likes


SELECT p.post_id, COUNT(l.like_id) AS total_likes_per_post,
	DENSE_RANK() OVER (ORDER BY COUNT(l.like_id) DESC) AS like_rnk
FROM post p
LEFT JOIN likes l
ON p.post_id = l.post_id
GROUP BY p.post_id


-- Finding all the posts and their comments 


SELECT p.post_id, p.post_caption, c.comment_text
FROM comment c
LEFT JOIN post p
ON c.post_id = p.post_id


-- Categorizing the posts based on the number of likes

SELECT p.post_id, COUNT(l.like_id) AS total_likes,
	CASE WHEN COUNT(l.like_id) < 2 THEN 'less_popular'
		 WHEN COUNT(l.like_id) = 2 THEN 'popular'
		 ELSE 'celebrity'
	END popularity
FROM post p
LEFT JOIN likes l
ON p.post_id = l.post_id
GROUP BY p.post_id


-- Which users have liked post_id 2?

SELECT u.user_id,u.user_name
FROM users u
LEFT JOIN likes l
ON u.user_id = l.user_id
WHERE l.post_id = 2


-- Which posts have no comments?

SELECT p.post_caption
FROM post p
LEFT JOIN comment c
ON p.post_id = c.post_id
WHERE c.comment_id IS NULL


-- Which posts were created by users who have no followers?

SELECT p.post_id,p.post_caption
FROM post p
LEFT JOIN users u 
ON p.user_id = u.user_id
LEFT JOIN follower f
ON u.user_id = f.user_id
WHERE f.follower_id IS NULL;


-- How many likes does each post have?

SELECT p.post_id, COUNT(l.like_id) AS total_likes_per_post
FROM post p
LEFT JOIN likes l
ON p.post_id = l.post_id
GROUP BY p.post_id


-- What is the average number of likes per post?

SELECT post_id,AVG(num_likes) AS avg_likes
FROM (
    SELECT p.post_id AS post_id,COUNT(l.like_id) AS num_likes
    FROM post p
    LEFT JOIN likes l ON p.post_id = l.post_id
    GROUP BY p.post_id
) AS likes_by_post
GROUP BY post_id


-- Which user has the most followers?

SELECT u.user_id,COUNT(f.follower_id) AS number_of_followers
FROM users u
LEFT JOIN follower f 
ON u.user_id = f.user_id
GROUP BY u.user_id
ORDER BY 2 DESC
LIMIT 1;


-- Rank the users by the number of posts they have created.

SELECT u.user_name,u.user_id, COUNT(p.post_id),
	DENSE_RANK() OVER (ORDER BY COUNT(p.post_id)) AS rank
FROM users u
LEFT JOIN post p
ON u.user_id = p.user_id
GROUP BY u.user_name,u.user_id


-- Rank the posts based on the number of likes.

SELECT p.post_id AS post_id,COUNT(l.like_id) AS total_likes_per_post,
	DENSE_RANK() OVER (ORDER BY COUNT(l.like_id) DESC) AS rank
FROM post p
LEFT JOIN likes l
ON p.post_id = l.post_id
GROUP BY p.post_id


-- Find all the comments and their users 

SELECT u.user_name,c.comment_text
FROM comment c
JOIN users u
ON c.user_id = u.user_id


-- Find all the posts and their comments 

SELECT p.post_caption, u.user_name AS commenter,c.comment_text
FROM post p
JOIN comment c
ON p.post_id = c.post_id
JOIN users u 
ON c.user_id = u.user_id
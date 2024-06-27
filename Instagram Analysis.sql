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
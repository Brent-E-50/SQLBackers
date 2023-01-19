-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

SELECT * FROM campaign;
CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"));


CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);
Drop table backers;
Select * from backers;
CREATE TABLE "backers" (
	"backer_id" varchar NOT NULL,
	"cf_id" int NOT NULL,
	"first_name" varchar(50) NOT NULL,
	"last_name" varchar(50) NOT NULL,
	"email" varchar (100) NOT NULL,
    CONSTRAINT "pk_backers" PRIMARY KEY (
        "backer_id"
     )
);



ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

ALTER TABLE "backers" ADD CONSTRAINT "fk_backers_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");
ABORT

--A SQL query is written and successfully executed that retrieves the number 
--of backer_counts in descending order for each 
--cf_id and for all the live campaigns.
SELECT backers_count, count(backers_count), cf_id, outcome
FROM campaign
WHERE outcome = 'live'
GROUP BY cf_id
ORDER BY backers_count DESC;


-----------------------------
--A SQL query is written and successfully executed that
--retrieves the number of backers in descending order 
--for each cf_id from the backers table.
SELECT COUNT(backer_id) AS Number_of_Backers, cf_id
FROM backers
GROUP BY cf_id
ORDER BY Number_of_Backers DESC;


-- Write a SQL query that creates a new table named 
-- email_contacts_remaining_goal_amount that contains the first name of each 
-- contact, the last name, the email address, and the remaining goal amount 
--(as "Remaining Goal Amount") in descending order for each live campaign.
SELECT c.first_name, c.last_name, c.email, l.remaining_amount 
AS Remaining_Goal_Amount
INTO email_contacts_remaining_goal_amount
FROM contacts c
JOIN campaign cam ON c.contact_id = cam.contact_id
JOIN live l ON l.cf_id = cam.cf_id
ORDER l.remaining_amount DESC;


-- Write a SQL query that creates a new table named 
-- email_backers_remaining_goal_amount 
--that contains the email addresses of the backers in descending order, 
--the first and the 
--last name of each backer, the cf_id, the company name, 
--the description, the end date of the 
-- campaign, and the remaining amount of the campaign goal as "Left of Goal".
SELECT b.email, b.first_name, b.last_name, b.cf_id, cam.company_name, 
cam.description, cam.end_date,  l.remaining_amount AS Left_of_Goal
INTO email_backers_remaining_goal_amount 
FROM backers b
INNER JOIN campaign cam ON b.cf_id = cam.cf_id
INNER JOIN live l ON l.cf_id = cam.cf_id
ORDER BY b.last_name, b.email;

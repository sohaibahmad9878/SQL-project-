-- create database
create database onlinebookstore;
-- switch to the database
\c onlinebookstore;

-- create tables
use onlinebookstore;
drop table if exists books;

create table books (
	Book_ID serial primary key,
    Title varchar(100),
    Author varchar(100),
    Genre varchar(50),
    Published_year INT,
    Price Numeric(10, 2),
    Stock INT
);
drop tables if exists customers;
create table customers (
	Customer_ID serial primary key,
    Name varchar(100),
    Email varchar(100),
    Phone varchar(50),
    City varchar(50),
    Country varchar(150)
);
drop tables if exists orders;
create table orders (
	Order_ID serial primary key,
	Customer_ID INT references customers(Customer_ID),
    Book_ID INT references books(Book_ID),
    Order_Date Date,
    Quantity INT,
	Total_Amount Numeric(10, 2)
);

-- import data into books tables
select * from books;
select * from customers;
select * from orders;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where genre='Fiction';

-- 2) Find the books published after the 1950:
select * from books
where published_year>1950;

-- 3) List all customers from the canada:
select * from customers
where country='canada';

-- 4) show orders placed in november 2023;
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available;
select sum(stock) as Total_stock
from books;

-- 6) Find the details of the most expensive books:
select * from books;
select * from books order by price desc limit 1;

-- 7) Show all the customers who orders more than 1 quantity of books:
select * from books;
select * from customers;
select * from orders;

select * from orders
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_amount>20;

-- 9) List all the genre available in the books tables:
select distinct genre from books;

-- 10) Find the book with the lowest stock;
select * from books;
select * from books
order by stock
limit 1;

-- 11) Calculate the total revenue generate from all orders:
select sum(Total_amount) as Total_revenue
from orders;

-- ADVANCE QUETION..

-- 1) Retrieve the total numbers of books sold for each genre:
use onlinebookstore;
select * from books;
select * from customers;
select * from orders;

select b.genre, sum(o.quantity) as Total_Book_Sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

-- 2) Find the average prrice of book in the "fantacy" genre:
select * from books;
select avg(price) as Average_Price
from books
where genre ='fantasy';

-- 3) List customers who have placed atleast 2 orders:
select * from books;
select * from customers;
select * from orders;

select o.customer_id, c.name, count(o.order_id) as Order_Count
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(order_id) >= 2;

-- 4) Find the most frequently ordered book:
select o.book_id, b.title, count(o.order_id) as Order_Count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id, b.title
order by Order_Count desc limit 3;

-- 5) Show the top 3 most expensive books of "fanatasy" genre:
select * from books 
where genre ="fantasy"
order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as Total_book_sold
from orders o 
join books b on o.book_id = b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, total_amount
from orders o
join customers c on o.customer_id = c.customer_id
where o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
select * from books;
select * from customers;
select * from orders;

select c.customer_id, c.name, sum(o.total_amount) as Total_Spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by  Total_Spent desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
select b.book_id , b.title, b.stock, coalesce(sum(o.quantity),0) as Order_Quantity,
	b.stock - coalesce(sum(o.quantity),0) as Remaining_Quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;
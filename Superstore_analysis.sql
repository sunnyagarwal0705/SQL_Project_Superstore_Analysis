use classicmodels;

/*	            Question Set 1 - Easy */

/* Q1: How many unique cities are the customers based in? */

select count(distinct city) as unique_city_count from customers;


/* Q2: What is the average price of products by product line? */

select productline, avg(MSRP) as average_product_price
from products
group by productline;


/* Q3: Which office has the least number of employees? */

select officecode, count(*) as employee_count 
from employees 
group by officecode 
order by employee_count limit 1;


/* Q4: What's the average credit limit for customers in each country? */

select country, truncate(avg(creditLimit),2) as avg_credit_limit
from customers
group by country;


/* Q5: List the products that have been ordered exactly 5 times. */

SELECT productCode
FROM orderdetails
GROUP BY productCode
HAVING COUNT(orderNumber) = 5;



/*            Question Set 2 - Moderate */

/* Q1: List the customer names who haven't placed any orders yet.*/

select c.customername 
from customers c left join orders o
on c.customernumber = o.customernumber
where o.ordernumber is null;

/* Q2:  Which customer has the highest total payments? */

select c.customernumber, c.customername, sum(amount) as total_payment from customers c left join payments p
on c.customernumber = p.customernumber
group by c.customernumber, customername
order by total_payment desc limit 1;


/* Q3: What are the names of customers who have placed more than 3 orders? */

select c.customername, count(*) as order_count from customers c left join orders o
on c.customernumber = o.customernumber
group by c.customernumber, c.customername
having order_count > 3;


/* Q4: Find the customers who have ordered the same product more than once. */

select distinct customernumber
from orders o join orderdetails od
on o.ordernumber = od.ordernumber
group by customernumber, productcode
having count(o.ordernumber) > 1;


/* Q5: List the employees who work in the same office as their manager. */

select e.employeenumber,e.firstname,e.lastname 
from employees e left join employees ee 
on e.reportsto = ee.employeenumber 
where e.officecode=ee.officecode;


/* Q6:  Who are the top 3 employees with the most customers? */
#output --> employeeID, firstName, lastName, total_customers

select c.salesrepemployeenumber,e.firstname,e.lastname, count(customernumber) as cust_count 
from customers c left join employees e 
on c.salesrepemployeenumber = e.employeenumber 
group by c.salesrepemployeenumber
order by cust_count desc;


/* Q7: What are the total payments received by each employee? */

select c.salesrepemployeenumber, sum(amount)
from payments p left join customers c
on p.customernumber = c.customernumber
group by c.salesrepemployeenumber;


/* Q8:  What are the total sales for each product line? */

select productline, sum(quantityordered*priceeach) as totalsales
from orderdetails o left join products p
on o.productcode = p.productcode
group by productline;


/* Q9:  Which employees have the same job title as their managers? */

select e.employeenumber, e.firstname, e.lastname
from employees e left join employees ee
on e.reportsto = ee.employeenumber
where e.jobtitle = ee.jobtitle;


/* Q10:  What is the total number of units sold for each product line? */

select productline, sum(quantityordered)
from orderdetails o left join products p
on o.productcode = p.productcode
group by productline;


/* Q11:  What are the names of employees who have processed orders that took more than 30 days to ship? */

SELECT DISTINCT employeeNumber
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE DATEDIFF(o.shippedDate, o.orderDate) > 30;


/* Q12:  What are the top 3 selling products? */

select o.productcode, productname, sum(quantityordered) as total_quantity
from orderdetails o left join products p
on o.productcode = p.productcode
group by o.productcode, productname
order by total_quantity desc
limit 3;


/* Q13:  Which cities are home to customers who have placed more than 5 orders? */

select c.customernumber,city ,count(ordernumber) as total_orders
from customers c join orders o
on c.customernumber = o.customernumber
group by c.customernumber,city
having total_orders > 5;


/* Q14:  Which product line has the widest range of prices? */

select productline, max(buyprice)-min(buyprice) as price_range 
from products 
group by productline 
order by price_range desc 
limit 1; 


/* Q15:   What is the minimum amount sold by each sales representative? */

SELECT salesRepEmployeeNumber, MIN(amount) AS min_amount
FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
GROUP BY salesRepEmployeeNumber;


/* Q16:  What are the names of the employees who have more than one direct report? */

SELECT e.reportsTo ,ee.firstname, ee.lastname , COUNT(*) AS num_reports
FROM employees e left join employees ee
on e.reportsto = ee.employeenumber
GROUP BY e.reportsTo, ee.firstname, ee.lastname
HAVING num_reports > 1;


/* Q17:  Which customers have ordered products from more than one product line? */

select o.customernumber, count(distinct productline) as total_pline
from orders o join orderdetails od on o.ordernumber = od.ordernumber
join products p on od.productcode=p.productcode
group by o.customernumber
having total_pline > 1;


/* Q18:  Who are the top 3 employees in terms of the number of customers they manage? */

select salesRepEmployeeNumber, count(customernumber) as total_cust
from customers
where salesRepEmployeeNumber is not null
group by salesRepEmployeeNumber
order by total_cust desc limit 3;


/* Q19:  What is the average shipping time for products ordered? */

select avg(datediff(shippeddate,orderdate)) as avg_ship_time
from orders;


/* Q20:  Which employee has processed the most number of orders? */

select salesrepemployeenumber, count(ordernumber) as total_orders
from orders o join customers c
on o.customernumber = c.customernumber
group by salesrepemployeenumber
order by total_orders desc limit 1;


/* Q21:  List the customers who have only ordered products from the product line 'Motorcycles'. */

select distinct customernumber
from orders o join orderdetails od on o.ordernumber = od.ordernumber
join products p on od.productcode = p.productcode
where productline = 'Motorcycles';


/* Q22:  What are names of the employees who sold products to customers in the country USA? */

select distinct firstname, lastname
from customers c join employees e
on c.salesRepEmployeeNumber = e.employeenumber
where country = 'USA';


/* Q23: List the offices that have more than 2 employees */

select officecode, count(employeenumber) as total_emp
from employees
group by officecode
having total_emp > 2;


/* Q24:  List the products that have never been ordered. */
select productcode, productname
from products
where productcode not in (select distinct productcode
	from orderdetails);


/* Q25:  What is the total amount of revenue generated by each sales representative? */

select salesRepEmployeeNumber, sum(amount)
from customers c join payments p
on c.customernumber = p.customernumber
group by salesRepEmployeeNumber;


/* Q26:  List the employees who do not manage any other employees */

select employeenumber
from employees
where employeenumber not in (select distinct reportsto from employees where reportsto is not null);


/* Q27:  What is the most common state for customers? */

select state, count(*) as cust_count
from customers
where state is not null
group by state
order by count(*) desc
limit 1;



/*             Question Set 3 - Advance */


/* Q1: List customers who have ordered more products than the customer with customerNumber = 103. */

select customernumber, count(distinct productcode) as total_products
from orders o join orderdetails oo
on o.ordernumber = oo.ordernumber
group by customernumber
having total_products > (select count(distinct productcode) 
	from orders o join orderdetails oo 
		on o.ordernumber = oo.ordernumber 
        where customernumber = 103);


/* Q2:  List the customers who have not ordered any products from the product line 'Motorcycles'. */

select distinct customernumber
from orders o join orderdetails od on o.ordernumber = od.ordernumber
join products p on od.productcode = p.productcode
where customernumber not in (select distinct customernumber
	from orders o join orderdetails od on o.ordernumber = od.ordernumber
	join products p on od.productcode = p.productcode
	where productline = 'Motorcycles');

/* Q3:  What are the names of the employees who have customers who have placed orders with more than 3 different products? */

select e.firstname, e.lastname
from employees e
join customers c on e.employeenumber = c.salesRepEmployeeNumber
join orders o on c.customernumber = o.customernumber
join orderdetails od on o.ordernumber = od.ordernumber
group by c.customernumber
having count(distinct productcode) > 3;


/* Q4:  Which customers have placed more orders than the average number of orders placed by all customers? */

select customernumber, count(ordernumber) as order_count
from orders
group by customernumber
having order_count > (select avg(order_count) from (select count(ordernumber) as order_count
	from orders
	group by customernumber) as sub);

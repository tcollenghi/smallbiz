/*
* Create Table News
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[News]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[News](
	[id] [nvarchar](32) NOT NULL,
	[visible] [bit] NOT NULL,
	[title] [nvarchar](256) NOT NULL,
	[date] [datetime] NOT NULL,
	[content] [nvarchar](4000) NULL,
	[imageUrl] [nvarchar](256) NULL,
	[imageAltText] [nvarchar](256) NULL,
	[displayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
* Create Table People
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[People]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[People](
	[id] [nvarchar](32) NOT NULL,
	[visible] [bit] NOT NULL,
	[firstName] [nvarchar](64) NOT NULL,
	[middleName] [nvarchar](64) NULL,
	[lastName] [nvarchar](64) NOT NULL,
	[title] [nvarchar](128) NULL,
	[description] [nvarchar](2048) NULL,
	[email] [nvarchar](256) NULL,
	[phone] [nvarchar](64) NULL,
	[fax] [nvarchar](64) NULL,
	[streetAddress] [nvarchar](128) NULL,
	[city] [nvarchar](128) NULL,
	[state] [nvarchar](64) NULL,
	[postalCode] [nvarchar](64) NULL,
	[country] [nvarchar](64) NULL,
	[imageUrl] [nvarchar](256) NULL,
	[imageAltText] [nvarchar](256) NULL,
	[displayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
* Create Table Category
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Category]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Category](
	[id] [nvarchar](32) NOT NULL,
	[visible] [bit] NOT NULL,
	[title] [nvarchar](256) NULL,
	[description] [nvarchar](2048) NULL,
	[imageUrl] [nvarchar](256) NULL,
	[imageAltText] [nvarchar](256) NULL,
	[parentCategoryId] [nvarchar](32) NULL,
	[displayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
* Create Table Item
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item](
	[id] [nvarchar](32) NOT NULL,
	[visible] [bit] NOT NULL,
	[title] [nvarchar](256) NOT NULL,
	[description] [nvarchar](2048) NULL,
	[price] [float] NULL,
	[inStock] [bit] NULL,
	[imageUrl] [nvarchar](256) NULL,
	[imageAltText] [nvarchar](256) NULL,
	[displayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
* Create Table Testimonails
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Testimonials]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Testimonials](
	[id] [nvarchar](32) NOT NULL,
	[visible] [bit] NOT NULL,
	[title] [nvarchar](256) NOT NULL,
	[date] [datetime] NOT NULL,
	[content] [nvarchar](1024) NULL,
	[testifier] [nvarchar](256) NULL,
	[testifierTitle] [nvarchar](256) NULL,
	[testifierCompany] [nvarchar](256) NULL,
	[imageUrl] [nvarchar](256) NULL,
	[imageAltText] [nvarchar](256) NULL,
	[displayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
* Create Table Categorization
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categorization]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Categorization](
	[itemId] [nvarchar](32) NOT NULL,
	[parentCategoryId] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[itemId] ASC,
	[parentCategoryId] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/*
 * Procedure GetRootCategories
 * */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRootCategories]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetRootCategories] AS SELECT id, visible, title, description, imageUrl, imageAltText, parentCategoryId FROM Category WHERE (parentCategoryId IS NULL)' 
END
GO
/*
* Procedure GetNonRootCategories
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNonRootCategories]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetNonRootCategories] @categoryId nvarchar(32) AS SELECT id, visible, title, description, imageUrl, imageAltText, parentCategoryId FROM Category WHERE (parentCategoryId = @categoryId)' 
END
GO
/*
* Procedure GetChildItems(@categoryId)
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetChildItems] @categoryId nvarchar(32) AS SELECT Item.id, Item.visible, Item.title, Item.description, Item.price, Item.inStock, Item.imageUrl, Item.imageAltText FROM Item INNER JOIN Categorization ON Item.id = Categorization.itemId WHERE (Categorization.parentCategoryId = @categoryId)' 
END
GO

/*
* Create Procedure GetNewsItem(@id)
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewsItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetNewsItem] @id nvarchar(32) AS SELECT id, visible, title, date, [content], imageUrl, imageAltText FROM News WHERE (id = @id)' 
END
GO
/*
* Create Procedure GetNews()
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNews]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetNews] AS SELECT id, visible, title, date, [content], imageUrl, imageAltText FROM News ORDER BY date DESC' 
END
GO
/*
* Create Procedure GetPeople()
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPeople]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPeople] AS SELECT id, visible, firstName, middleName, lastName, title, description, email, phone, fax, streetAddress, city, state, postalCode, country, imageUrl, imageAltText FROM People ORDER BY displayOrder' 
END
GO
/*
* Create Procedure GetTestimonials()
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTestimonials]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetTestimonials] AS SELECT id, visible, title, date, [content], testifier, testifierTitle, testifierCompany, imageUrl, imageAltText FROM Testimonials ORDER BY displayOrder' 
END
GO
/*
* Create Procedure GetItem(@id)
* */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetItem] @itemId nvarchar(32) AS SELECT Item.id, Item.visible, Item.title, Item.description, Item.price, Item.inStock, Item.imageUrl, Item.imageAltText FROM Item WHERE (Item.id = @itemId)' 
END
GO
/*
* Create Foreign Key Relationships
* */
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Category__parent__5165187F]') AND parent_object_id = OBJECT_ID(N'[dbo].[Category]'))
ALTER TABLE [dbo].[Category]  WITH CHECK ADD FOREIGN KEY([parentCategoryId])
REFERENCES [dbo].[Category] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Categoriz__itemI__5FB337D6]') AND parent_object_id = OBJECT_ID(N'[dbo].[Categorization]'))
ALTER TABLE [dbo].[Categorization]  WITH CHECK ADD FOREIGN KEY([itemId])
REFERENCES [dbo].[Item] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Categoriz__paren__60A75C0F]') AND parent_object_id = OBJECT_ID(N'[dbo].[Categorization]'))
ALTER TABLE [dbo].[Categorization]  WITH CHECK ADD FOREIGN KEY([parentCategoryId])
REFERENCES [dbo].[Category] ([id])
/*
* Insert Data: table Category
*/
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('01',1,'Amet','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'cat01.jpg', 'image of Category 1', null , 1)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('02',1,'Consectetuer','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'cat02.jpg', 'image of Category 2' , null , 2)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('03',1,'Adipiscing','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'cat03.jpg', 'image of Category 3', null, 3)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('04',1,'Pharetra Diam','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'cat04.jpg', 'image of Category 4', null, 4)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('05',1,'Ullamcorper','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'cat06.jpg', 'image of Category 5', null, 5)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('06',1,'Sed eget Magna','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-1.jpg', 'image of Category 6', '01', 6)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('07',1,'Vestibulum','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-2.jpg', 'image of Category 7', '01', 7)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('08',1,'Proin Feugiat Enim','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-3.jpg', 'image of Category 8', '01', 8)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('09',1,'Vivamus Gravida','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-4.jpg', 'image of Category 9', '01', 9)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('10',1,'Pellentesque','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-5.jpg', 'image of Category 10', '02', 10)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('11',1,'Maecenas auctor Luctus','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-6.jpg', 'image of Category 11', '03', 11)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('12',1,'Blandit','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-7.jpg', 'image of Category 11', '03', 12)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('13',1,'Eu Mollis Nunc','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-8.jpg', 'image of Category 11', '04', 13)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('14',1,'Luctus Dictum','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-9.jpg', 'image of Category 11', '04', 14)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('15',1,'Rhoncus','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-10.jpg', 'image of Category 11', '05', 15)
INSERT INTO Category (id, visible, title, description, imageUrl, imageAltText, parentCategoryId, displayOrder) VALUES ('16',1,'Elementum','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt', 'product-small-11.jpg', 'image of Category 11', '05', 16)
/*
* Insert Data: table Item
*/
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('01',1,'Proin vitae','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item01.jpg', 'image of item 1', 1)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('02',1,'Felis Non Purus','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item02.jpg', 'image of item 2', 2)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('03',1,'Eleifend Consequat','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item01.jpg', 'image of item 3', 3)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('04',1,'Pellentesque','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item02.jpg', 'image of item 4', 4)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('05',1,'Sodales Mollis','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item01.jpg', 'image of item 5', 5)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('06',1,'Vel Purus','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item02.jpg', 'image of item 6', 6)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('07',1,'Mollis','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item01.jpg', 'image of item 7', 7)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('08',1,'Tincidunt','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed ', 12.00,1, 'item02.jpg', 'image of item 8', 8)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('09',1,'Nullam Tellus','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed', 12.00,1, 'item01.jpg', 'image of item 9', 9)
INSERT INTO Item (id, visible, title, description, price, inStock, imageUrl, imageAltText, displayOrder) VALUES ('10',1,'Fusce Vulputate','Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed', 12.00,1, 'item02.jpg', 'image of item 10', 10)
/*
* Insert Data: table Categorization
* a child item may belong to multiple parent categories
*/
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('01','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('02','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('03','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('04','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('05','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('06','05');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('01','06');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('02','06');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('03','06');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('04','07');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('05','07');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('06','07');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('07','08');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('01','09');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('02','09');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('03','09');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('06','10');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('07','10');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('08','10');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('09','10');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('10','10');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('06','12');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('07','12');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('08','12');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('09','12');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('10','12');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('06','14');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('07','14');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('08','14');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('09','14');
INSERT INTO Categorization (itemId, parentCategoryId) VALUES ('10','14');
/*
* Insert Data: table Testimonials
*/
INSERT INTO Testimonials (id, visible, title, date, content, testifier, testifierTitle, testifierCompany, imageUrl, imageAltText, displayOrder) VALUES     ('01', 1, 'Northwind Traders sadipscing elitr Fabrikam', '07-12-2006 03:00:00', 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.','Pernille Halberg', 'Director', 'Northwind Traders', 'person-3.jpg', 'Pernille Halberg - Northwind Traders', 1);
INSERT INTO Testimonials (id, visible, title, date, content, testifier, testifierTitle, testifierCompany, imageUrl, imageAltText, displayOrder) VALUES     ('02', 1, 'Contoso Pharmaceuticals sadipscing elitr Fabrikam', '07-12-2006 12:00:00', 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.','Darren Parker', 'Manager', 'Contoso Pharmaceuticals', '', 'Darren Parker -  Manager, Contoso Pharmaceuticals',3);
INSERT INTO Testimonials (id, visible, title, date, content, testifier, testifierTitle, testifierCompany, imageUrl, imageAltText, displayOrder) VALUES     ('03', 1, 'Contoso Pharmaceuticals sadipscing elitr Fabrikam', '07-10-2006 02:34:00', 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.','Nielsen Bardenfleth', 'Engineer', 'Contoso Pharmaceuticals', 'person-6.jpg', 'Nielsen Bardenfleth-  Manager, Contoso Pharmaceuticals',2);
/*
* Insert Data: table News
*/
INSERT INTO News (id, visible, title, date, [content], imageUrl, imageAltText, displayOrder) VALUES     ('01', 1, 'Consectetur Fabrikam Dolor Sit Amet', '02-12-2006 12:00:00', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididuntt labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'news.jpg', 'Fabrikam - anim id est laborum', 1)
INSERT INTO News (id, visible, title, date, [content], imageUrl, imageAltText, displayOrder) VALUES     ('02', 1, 'Fabrikam Consectetur Adipisicing Elit', '03-12-2006 12:00:00', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'news-2.jpg', 'Fabrikam - anim id est laborum', 2)
INSERT INTO News (id, visible, title, date, [content], imageUrl, imageAltText, displayOrder) VALUES     ('03', 1, 'Mollit Anim Id Est Laborum', '03-10-2006 12:00:00', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'news1.jpg', 'Fabrikam - anim id est laborum', 2)
/*
* Insert Data: table People
*/
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('01',1,'Jesper','','Aaberg','President','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.', 'aaberg@fabrikam.com','2025550100','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-1.jpg','Jesper - President', 1)
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('11',1,'Del Moral Negugogor','','Oscar','Chairman','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.','lene@fabrikam.com','2025550100','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-4.jpg','Del Moral Negugogor', 2)
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('12',1,'Dziegiel','Hanefeld','Andreas','Editor','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.', 'Dziegiel@fabrikam.com','2025550102','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-5.jpg','Dziegiel', 3)
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('02',1,'Aalling','','Lene','Editor','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.', 'Aalling@fabrikam.com','2025550102','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-2.jpg','Aalling', 3)
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('03',1,'Abbas','','Syed','Editor','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.', 'syed@fabrikam.com','2025550102','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-7.jpg','Abbas - Editor', 3)
INSERT INTO People (id, visible, firstName, middleName, lastName,title, description, email, phone, fax, streetAddress, city , state, postalCode, country, imageUrl, imageAltText , displayOrder) VALUES ('04',1,'Nielsen','Bardenfleth','Thomas','Editor','Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exercitation ulliam corper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem veleum iriure dolor in hendrerit in vulputate velit esse molestie consequat.', 'Nielsen@fabrikam.com','2025550102','2025556100', '567 Main St','Buffalo','NY','99887','USA','person-4.jpg','Image of Nielsen', 3)


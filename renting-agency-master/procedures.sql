CREATE OR REPLACE PROCEDURE InsertPropertyRecord(
	pid in number,
	rent in double precision, rentHike in double precision,
	floors in number,
	constructionYear in number,
	address in varchar2,
	startDate in date, endDate in date,
	plinth in double precision,
	locality in varchar2,
	owner in varchar2) is
owner_count number;
begin

	SELECT COUNT(*) INTO owner_count
	FROM LANDLORD
	WHERE aadharID=owner;

	IF owner_count = 0 THEN
		INSERT INTO LANDLORD VALUES(owner);
	END IF;

	INSERT INTO Property VALUES(
		pid,
		rent, rentHike,
		floors,
		constructionYear,
		address,
		startDate, endDate,
		plinth,
		locality,
		owner);
end;
/

CREATE OR REPLACE PROCEDURE CreateNewUser(
	aadharID VARCHAR2,
	age NUMBER,
	email VARCHAR2,
	password varchar2,
	name VARCHAR2,
	doorNo VARCHAR2,
	street VARCHAR2,
	city VARCHAR2,
	state VARCHAR2,
	pin NUMBER
) is
begin
	INSERT INTO Users VALUES(
		aadharID,
		age,
		email,
		password,
		name,
		doorNo,
		street,
		city,
		state,
		pin);
end;
/

CREATE OR REPLACE PROCEDURE PRINT_PROPERTY(property_rec in property%rowtype) is
	res_count number;
	bed number;
	r double precision;
	cursor facility_cursor is
		select facility from facility
		where pid=property_rec.pid;
	facility_rec varchar(50);
begin
	select count(*) into res_count 
	from residential 
	where pid = property_rec.pid;

	DBMS_OUTPUT.PUT_LINE('PID: ' || property_rec.pid);
	DBMS_OUTPUT.PUT_LINE('Rent: ' || property_rec.rent);
	DBMS_OUTPUT.PUT_LINE('Rent Hike: ' || property_rec.renthike);
	DBMS_OUTPUT.PUT_LINE('Floors: ' || property_rec.floors);
	DBMS_OUTPUT.PUT_LINE('Construction Year: ' || property_rec.constructionyear);
	DBMS_OUTPUT.PUT_LINE('Address: ' || property_rec.address);
	DBMS_OUTPUT.PUT_LINE('Start Date: ' || property_rec.startdate);
	DBMS_OUTPUT.PUT_LINE('End Date: ' || property_rec.enddate);
	DBMS_OUTPUT.PUT_LINE('Plinth: ' || property_rec.plinth);
	DBMS_OUTPUT.PUT_LINE('Locality: ' || property_rec.locality);
	IF res_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('Property Type: Residential');
		select bedrooms into bed 
		from residential
		where pid = property_rec.pid;
		DBMS_OUTPUT.PUT_LINE('Bedrooms: ' || bed);
		OPEN facility_cursor;
		DBMS_OUTPUT.PUT_LINE('Facilities: ');
		LOOP
			FETCH facility_cursor into facility_rec;
			EXIT WHEN facility_cursor%notfound; 
			DBMS_OUTPUT.PUT_LINE(facility_rec);
		END LOOP;
		CLOSE facility_cursor;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Property Type: Commercial');
		select roi into r 
		from Commercial
		where pid = property_rec.pid;
		DBMS_OUTPUT.PUT_LINE('ROI: ' || r || '%');
	END IF;
	DBMS_OUTPUT.PUT_LINE('---------------------------');
end;
/

CREATE OR REPLACE PROCEDURE GetPropertyRecords(ownerID in varchar2) is
	cursor property_cur is
		select * from property 
		where aadharID=ownerID;
	property_rec property%rowtype;
	ownername varchar(30);
begin
	OPEN property_cur;
	select name into ownername from users where aadharID=ownerID;
	DBMS_OUTPUT.PUT_LINE('Displaying properties owned by '||ownername);
	LOOP
		FETCH property_cur into property_rec;
		EXIT WHEN property_cur%notfound;
		PRINT_PROPERTY(property_rec);
	END LOOP;
	CLOSE property_cur; 
end;
/

CREATE OR REPLACE PROCEDURE SearchPropertyForRent(locale IN varchar2) AS
	cursor property_cur is
		select * from property 
		where locality=locale;
	property_rec property%rowtype;
BEGIN
	open property_cur;
	LOOP
		FETCH property_cur into property_rec;
		EXIT WHEN property_cur%notfound;
		PRINT_PROPERTY(property_rec);
	END LOOP;
	close property_cur;
END;
/

CREATE OR REPLACE PROCEDURE AddTenant(
	property in number,
	t in varchar2, 
	commission in double precision,
	startDate in date,
	endDate in date
) as
	tenantCount number;
begin
	SELECT COUNT(*) into tenantCount 
	FROM TENANT
	WHERE aadharID=t;

	IF tenantCount <> 1 THEN
		INSERT INTO TENANT VALUES(t);
	END IF;

	INSERT INTO RENT VALUES(
		property,
		t,
		commission,
		startDate,
		endDate
	)	;
end;
/

-- exec AddTenant(146, '3408', 1500.0, '25-AUG-06', '1-MAY-2007');

CREATE OR REPLACE PROCEDURE GetTenantDetails(PropID IN INTEGER) AS
	tenant_rec users%rowtype;
	cursor tenant_cursor is
		select * from users 
		where aadharID in (select aadharID from rent where pid = propID);
begin
	OPEN tenant_cursor;
	LOOP
		FETCH tenant_cursor INTO tenant_rec;
		EXIT WHEN tenant_cursor%notfound;
		DBMS_OUTPUT.PUT_LINE('AADHAR ID: ' || tenant_rec.aadharID); 
		DBMS_OUTPUT.PUT_LINE('Name: ' || tenant_rec.name); 
		DBMS_OUTPUT.PUT_LINE('Age: ' || tenant_rec.age); 
		DBMS_OUTPUT.PUT_LINE('Email: ' || tenant_rec.email); 
		DBMS_OUTPUT.PUT_LINE('Address: ' || tenant_rec.doorNo || ', ' || tenant_rec.street || ', ' || tenant_rec.city || ', ' || tenant_rec.state || ', ' || tenant_rec.pin);
	END LOOP;
	CLOSE tenant_cursor;
end;
/

CREATE OR REPLACE PROCEDURE GetRentHistory(
	propID IN varchar2
) AS
	rent_rec rent%rowtype;
	cursor rent_cursor is
		select * from rent where pid = propid;
	tenant_name varchar(50);
begin
	open rent_cursor;

	loop
		fetch rent_cursor into rent_rec;

		exit when rent_cursor%notfound;

		select name into tenant_name 
		from users 
		where aadharID=rent_rec.aadharID;

		DBMS_OUTPUT.PUT_LINE('PID: ' || rent_rec.pid);
		DBMS_OUTPUT.PUT_LINE('Aadhar ID: ' || rent_rec.aadharID);
		DBMS_OUTPUT.PUT_LINE('Tenant Name: ' || tenant_name);
		DBMS_OUTPUT.PUT_LINE('Commission: ' || rent_rec.commission);
		DBMS_OUTPUT.PUT_LINE('Start Date: ' || TO_CHAR(rent_rec.startDate, 'DD-MON-YYYY'));
		DBMS_OUTPUT.PUT_LINE('End Date: ' || TO_CHAR(rent_rec.endDate, 'DD-MON-YYYY'));
		DBMS_OUTPUT.PUT_LINE('---------------------------');
	end loop;
	close rent_cursor;
END GetRentHistory;
/

--- *** OTT카테고리 테이블 생성 *** ---
create table tbl_ottcategory
(categorynum number not null                                -- 카테고리 번호
,categoryname varchar2 not null                             -- 카테고리명
,categorylogo varchar2 not null                             -- 카테고리로고 이미지파일명
,constraint PK_tbl_ottcategory primary key(categorynum));

select *
from tbl_ottcategory;

--- *** OTT카테고리 시퀀스 생성 *** ---
create sequence seq_ottcategory
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '넷플릭스', 'netflix.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '디즈니플러스', 'disneyplus.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '왓챠', 'watcha_black.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '유튜브', 'youtubepremium.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '웨이브', 'wavve.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '티빙', 'tving_new.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '라프텔', 'laftel.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '애플원', 'appleone.png');
insert into tbl_ottcategory(categorynum, categoryname, categorylogo)
values(seq_ottcategory.nextval, '아마존프라임비디오', 'amazonprimevideo.png');

commit;

select categorynum, categoryname, categorylogo
from tbl_ottcategory
order by categorynum;

--------------------------------------------------------------------------------

--- *** 회원 테이블 생성 *** ---
create table tbl_member
(id varchar2(100) not null                  -- 아이디
,pwd varchar2(100) not null                 -- 비밀번호
,name varchar2(20) not null                 -- 이름
,birthday varchar2(20) not null             -- 생년월일
,phone varchar2(100) not null               -- 휴대전화
,email varchar2(100) not null               -- 이메일
,memberstatus number(1) default 1 not null  -- 회원상태(0: 휴면, 1: 정상)
,constraint PK_tbl_member primary key(id));
-- Table TBL_MEMBER이(가) 생성되었습니다.

select *
from tbl_member;

--------------------------------------------------------------------------------

--- *** 파티 테이블 생성 *** ---
drop table  tbl_party purge;

create table tbl_party
(partynum varchar2(20) not null
,partyname varchar2(100) not null
,startdate date default sysdate not null
,enddate date not null
,nop number(2) not null
,charge number(6) not null
,fk_categorynum number not null
,partyleaderid varchar2(100) not null
,partymemberid varchar2(100) not null
,partystatus number(1) default 0 not null
,constraint PK_tbl_party primary key(partynum)
,constraint FK_categorynum foreign key(fk_categorynum) references tbl_ottcategory(categorynum)
,constraint FK_partyleaderid foreign key(partyleaderid) references tbl_member(id)
,constraint FK_partymemberid foreign key(partymemberid) references tbl_member(id));
-- Table TBL_PARTY이(가) 생성되었습니다.

--------------------------------------------------------------------------------
drop table tbl_log purge;
--- *** 로그인 기록 테이블 생성 *** ---
create table tbl_log
(fk_id varchar2(100) not null
,logindate date default sysdate not null
,clientip varchar2(20) not null
,constraint FK_id foreign key(fk_id) references tbl_member(id));
-- Table TBL_LOG이(가) 생성되었습니다.

update tbl_log
set logindate = add_months(logindate, 13)
where fk_id = 'dh1201';

commit;

select trunc(months_between(sysdate, to_date(nvl(to_char(logindate, 'yyyy-mm-dd'), to_char(sysdate, 'yyyy-mm-dd')), 'yyyy-mm-dd'))) AS lastlogin
from tbl_log
where fk_id = 'limsh'
order by logindate desc;

select to_char(logindate, 'yy/mm/dd hh24:mi:ss') AS logindate
from tbl_log
where fk_id = 'limsh'
order by logindate desc;

select trunc(sysdate - to_date(nvl(to_char(logindate, 'yyyy-mm-dd'), to_char(sysdate, 'yyyy-mm-dd')), 'yyyy-mm-dd')) as date_between
from tbl_log
where fk_id = 'limsh'
order by logindate desc;

select trunc(months_between(sysdate, nvl(logindate, sysdate))) as lastlogin
from tbl_log
where fk_id = 'limyuna';

update tbl_log
set logindate = add_months(logindate, 13)
where fk_id = 'limsh';

commit;

create table test
(testdate date
,teststatus number(1));

insert into test(testdate, teststatus)
values(sysdate, 0);
insert into test(testdate, teststatus)
values(sysdate - 1, 0);
insert into test(testdate, teststatus)
values(sysdate-2, 0);

select *
from test
order by teststatus asc, testdate desc;

--------

select to_date('2022-07-07', 'yyyy-mm-dd') - to_date('2022-05-07', 'yyyy-mm-dd')
from dual;

select partynum
from tbl_party
where partynum = '12345678';

select partynum, partyname, startdate, enddate, nop, charge, fk_categorynum, partyleaderid, partystatus, ottid, ottpwd
from tbl_party
where partynum = #{partynum};

--------------------------------------------------------------------------------

--- *** 파티원 테이블 생성 *** ---
create table tbl_partymember
(partynum varchar2(20) not null
,partymemberid varchar2(100) not null
,constraint FK_partynum foreign key(partynum) references tbl_party(partynum)
,constraint FK_partymemberid foreign key(partymemberid) references tbl_member(id));
-- Table TBL_PARTYMEMBER이(가) 생성되었습니다.

select partymemberid
from tbl_partymember
where partymemberid = '';

select P.partynum, partyname, startdate, enddate, nop, charge, fk_categorynum, partyleaderid, partystatus, ottid, ottpwd
from tbl_party P
join tbl_partymember M
on P.partynum = M.partynum
where M.partymemberid = 'limsh';

select partynum, partyname, startdate, enddate, nop, charge, fk_categorynum, partyleaderid, partystatus, ottid, ottpwd
from tbl_party
where partyleaderid = 'limyuna';

select id
from tbl_member
where id = 'limsh' and pwd = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382';

select categoryname, P.partynum, partyname, startdate, enddate, nop, charge, fk_categorynum, partyleaderid, partystatus, ottid, ottpwd
from tbl_party P
join tbl_partymember M
on P.partynum = M.partynum
join tbl_ottcategory C
on C.categorynum = p.fk_categorynum
where M.partymemberid = 'hongkd' and P.partystatus = 0;

select count(*) as attendmembercnt
from tbl_partymember
where partynum = '65507785';

select nop
from tbl_party
where partynum = '65507785';

select attendmembercnt, nop
from
(
    select count(*) as attendmembercnt
    from tbl_partymember
    where partynum = '00461178'
) A
cross JOIN
(
    select nop, partynum
    from tbl_party
    where partynum = '00461178'
) B;

update tbl_party
set partystatus = 1
where partystatus = 1;

commit;
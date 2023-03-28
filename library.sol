//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Library{
    struct book{
        uint bookid;
        string name;
        string author;
        uint addedon;
        bool isavail;
    }
    struct reader{
        uint readerid;
        string name;
        uint issued;
        uint returndate;
    }
    event Addbook(uint bookid, string name);
    event Addreader(uint readerid, string name);
    event Issuebook(uint bookid, uint readerid, uint returndate);
    event Returnbook(uint bookid, uint readerid, uint returndate);
    mapping(uint=>book) librarybooks;
    mapping(uint=>reader) libraryreaders;
    uint bookno=1000;
    uint readerno=1;
    function addbook(
        string memory _name,
        string memory _author
    )public{
        librarybooks[bookno].bookid=bookno;
        librarybooks[bookno].name=_name;
        librarybooks[bookno].author=_author;
        librarybooks[bookno].addedon=block.timestamp;
        librarybooks[bookno].isavail=true;
        emit Addbook(bookno, _name);
        bookno+=1;
    }
    function addreader(
        string memory _name
    )public{
        libraryreaders[readerno].readerid=readerno;
        libraryreaders[readerno].name=_name;
        libraryreaders[readerno].issued=0;
        libraryreaders[readerno].returndate=0;
        emit Addreader(readerno, _name);
        readerno+=1;
    }
    function issuebook(
        uint _bookid, 
        uint _readerid
    )public{
        require(libraryreaders[_readerid].issued==0, "Reader already has a book issued");
        require(librarybooks[_bookid].isavail==true, "Book already issued by someone else");
        libraryreaders[_readerid].issued=_bookid;
        libraryreaders[_readerid].returndate=block.timestamp +7 days;
        librarybooks[_bookid].isavail=false;
        emit Issuebook(_bookid, _readerid, block.timestamp + 7 days);
    }
    function returnbook(
        uint _bookid,
        uint _readerid
    )public{
        require(libraryreaders[_readerid].issued!=0, "Reader has no book");
        libraryreaders[_readerid].issued=0;
        libraryreaders[_readerid].returndate=0;
        librarybooks[_bookid].isavail=true;
        emit Returnbook(_bookid, _readerid, block.timestamp);
    }
}
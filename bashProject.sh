#!/bin/bash
#A simple database mangement system by : Nouran Elshaer , Nadine Abdelfattah
#mkdir DBMS 2>> /dev/null
clear
function menu()
{
        echo "Please select 1 to create database"
        echo "Please select 2 to list databases"
        echo "Please select 3 to connect to database"
        echo "Please select 4 to drop database"
        echo "Please select 5 to exit"
        read ch
        case $ch in
                1) createDB
                        ;;
                2) listDB
                        ;;
                3) connectToDB
                        ;;
                4) DropDB
                        ;;
                5) exit
                        ;;
                *) echo "Wrong choice"
        esac

}
function createDB()
{
    if ! [[ -d ./DBMS ]]
        then
            mkdir DBMS
        fi
    echo "Please enter database name"
    read name
    if [ -z $name ]
    then
        echo "Empty input ,please enter database name"
    createDB
    elif  [[ -d ./database/$name ]]
    then
        echo "Database already exists !"
        createDB
    else
        mkdir ./DBMS/$name
    fi
}
function listDB()
{
    if ! [[ -d ./DBMS ]]
        then
            mkdir DBMS
    fi
    ls ./DBMS
}
function connectToDB()
{
        echo "Please enter a database name from below to connect to it.. "
        ls ./DBMS
        read dbname
        cd ./DBMS/$dbname 2>> /dev/null
        if [[ $? == 0 ]]
        then
                echo "Connected to database successfully"
        else
                echo "Unexpected error happened, we are sorry.."

        fi
        tables

}
function DropDB()
{
        echo "Please enter a database name from below to delete it.. "
        ls ./DBMS
        read dbname
        if [ -z "$dbname" ]
        then
                echo "Empty input, Please try again"
                deleteDB
        else
             rm -r ./DBMS/$dbname
        fi
        if [[ $? == 0 ]]
        then
                echo "Database removed successfully.."
        else
                echo "Unexpected error happened, we are sorry.."
        fi
        menu
}
function tables()
{
        echo "Please select 1 to create new table"
        echo "Please select 2 to list available tables"
        echo "Please select 3 to drop table"
        echo "Please select 4 to insert into table"
        echo "Please select 5 to select from table"
        echo "Please select 6 to delete from table"
        read ch
        case $ch in
                1)createTable
                        ;;
                2)ls .; tables
                        ;;
                3)dropTable
                        ;;
                4)insertIntoTable
                        ;;
                5)selectFromtable
                        ;;
                6)deleteFromTable
                        ;;
		7) exit
			;;
                *)echo "Wrong input.."
                        ;;
        esac
}
function createTable()
{
    echo "Please enter table name"
    read tableName
    
     if [ -z "$tableName" ]
        then
        echo "Empty value,please try again!!"
           createTable $1
        elif ! [[ $tableName =~ ^[_a-zA-Z]+$ ]]
		then
        echo "invalid name ,please try again!!"
          createTable $1
        elif  [[ -f ./DBMS/$1/$tableName ]]
        then
        echo "you have table with this name ,please choose another name !!"
            createTable $1

        elif [[ $tableName  == MetaData* ]]
        then
                echo " you can not start database with metaData (reserved word) ,please choose another name !!"

        else
             touch ./DBMS/$1/$tableName
             touch ./DBMS/$1/metaData_$tableName
             numofCols $1 $tableName
        fi
}

function numofCols()
{
    echo "Please enter the number of columns of table $tableName"
    read colNum
      if [[ "$?" != "0" ]] ; then
        rm  ./DBMS/$1/$tableName
       rm  ./DBMS/$1/metaData_$tableName
    return 1
        fi

     if [ -z "$colNum" ]
    then
      echo "Empty value,please try again!!"

    numofCols $1 $2
    elif ! [[ $colNum =~ ^[0-9]+$ ]]
    then
      echo"wrong format "

        numofCols $1 $2
    elif [[ $colNum -lt 2 ]]
    then
      echo "column numbers can not be less than 2"
      numofCols $1 $2
    else
         for i in $(seq $colNum)
            do
            if [[ i -eq 1 ]]
            then
                pkValidation $1 metaData_$2

            else
                columnValidations $1 metaData_$2
            fi
        done

        echo "table is created successfully"
                              tables
                              exit


    fi
}
function pkValidation()
{
    pkFlag=1
    echo "Please enter your primary key"
    read colName
    if [ -z "$colName" ]
    then
            echo"Empty value,please try again!!"

    pkValidations $1 $2
    elif ! [[ $colName =~ ^[a-zA-Z]+$ ]]
    then
            echo"$colName is not valid format,please try again!!"

    pkValidations $1 $2
    else
        echo -n $colName >> ./DBMS/$1/$2

       # specifyColumnDataType $colName $1 $2 $pkFlag
        echo -e ":pk" >> ./DBMS/$1/$2

    fi
}

function columnValidation()
{
    echo "Please enter column name"
    read $colName
    if [ -z "$colName" ]
    then
            echo "Empty value,please try again!!"

    columnValidation $1 $2
    elif ! [[ $colName =~ ^[_a-zA-Z]+$ ]]
    then
            echo "$colName is not valid format,please try again!!"
    columnValidation $1 $2
    elif  grep -w "$colName" ./DBMS/$1/$2
    then
            echo"already exists"

        columnValidation  $1 $2
    else
      echo -n $colName >> ./DBMS/$1/$2
     #specifyColumnDataType $colName $1 $2
    fi
}
menu
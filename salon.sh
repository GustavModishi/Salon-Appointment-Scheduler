#! /bin/bash


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~~~~~~ MY SALON ~~~~~~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"


MAIN_MENU() {
 
if [[ $1 ]]
then
  echo -e "\n$1"
fi

SERVICE=$($PSQL "SELECT service_id, name FROM services")

echo "$SERVICE" | while read SERVICE_ID BAR NAME
do
echo "$SERVICE_ID) $NAME"
done

echo -e "\nPlease select a service?"
read SERVICE_ID_SELECTED 
SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED ") 
# if input is not found
if [[ -z $SERVICE_ID_SELECTED ]]
then
# send to main menu
MAIN_MENU

else

  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

   # if customer doesn't exist
   if [[ -z $CUSTOMER_NAME ]]
   then
     # get new customer name
     echo -e "\nWhat's your name?"
     read CUSTOMER_NAME

     # insert new customer
     INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 

   fi
   echo -e "\nWhat time would you like to set your apointment?"
   read SERVICE_TIME
   
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
   INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
   NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED") 
   echo -e "I have put you down for a $NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}
MAIN_MENU

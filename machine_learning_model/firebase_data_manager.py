import firebase_admin
from firebase_admin import credentials, firestore
import time
import pandas as pd
import recommender 

# Initialize SDK
cred = credentials.Certificate("firebase_config.json")
firebase_admin.initialize_app(cred)

# Initialize Firestore instance
firestore_db = firestore.client()

# Function to fetch restaurant data from rest_details collection
def fetch_restaurant_data():
    """
    Fetches restaurant data from the Firestore 'rest_details' collection.

    Returns:
    List[dict]: List of dictionaries containing restaurant data.
    """
    # Retrieve all documents from rest_details collection
    rest_details_ref = firestore_db.collection('rest_details')
    rest_details_docs = rest_details_ref.stream()

    # List to store restaurant data
    restaurant_data = []

    # Iterate over documents
    for doc in rest_details_docs:
        # Extract document data
        data = doc.to_dict()
        # Extract restaurant ID (document ID)
        restaurant_id = doc.id
        # Extract name, latitude, and longitude
        name = data.get('name')
        latitude = data.get('latitude')
        longitude = data.get('longitude')
        # Append data to list
        restaurant_data.append({'Restaurant ID': restaurant_id, 'Restaurant Name': name, 'Latitude': latitude, 'Longitude': longitude})

    return restaurant_data

# Function to create DataFrame from restaurant data
def create_dataframe(restaurant_data):
    """
    Creates a DataFrame from the restaurant data.

    Args:
    restaurant_data (List[dict]): List of dictionaries containing restaurant data.

    Returns:
    pandas.DataFrame: DataFrame containing restaurant data.
    """
    # Create DataFrame
    df = pd.DataFrame(restaurant_data)
    return df

# Fetch restaurant data
restaurant_data = fetch_restaurant_data()

# Create DataFrame
df_restaurants = create_dataframe(restaurant_data)

# Function to fetch latitude and longitude using restaurant ID
def fetch_location(restaurant_id):
    """
    Fetches latitude and longitude using restaurant ID.

    Args:
    restaurant_id (str): ID of the restaurant.

    Returns:
    Tuple[float, float]: Latitude and longitude.
    """
    # Retrieve document
    restaurant_ref = firestore_db.collection('rest_details').document(restaurant_id)
    restaurant_doc = restaurant_ref.get()

    if restaurant_doc.exists:
        # Access document data
        data = restaurant_doc.to_dict()
        # Fetch latitude and longitude
        latitude = data.get('latitude')
        longitude = data.get('longitude')
        return latitude, longitude
    else:
        return None, None

# Function to fetch document IDs from food_details collection
def fetch_food_detail_document_ids():
    """
    Fetches document IDs from the 'food_details' collection in Firestore.

    Returns:
    List[str]: List of document IDs.
    """
    food_details_ref = firestore_db.collection('food_details')
    food_details_docs = food_details_ref.stream()

    document_ids = []
    for doc in food_details_docs:
        document_ids.append(doc.id)

    return document_ids

# Fetch document IDs from food_details collection
document_ids = fetch_food_detail_document_ids()

# Function to fetch latitude and longitude using deliverer ID
def fetch_deliverer_location(deliverer_id):
    """
    Fetches latitude and longitude using deliverer ID.

    Args:
    deliverer_id (str): ID of the deliverer.

    Returns:
    Tuple[float, float]: Latitude and longitude.
    """
    # Retrieve document
    deliverer_ref = firestore_db.collection('deliverer_details').document(deliverer_id)
    deliverer_doc = deliverer_ref.get()

    if deliverer_doc.exists:
        # Access document data
        data = deliverer_doc.to_dict()
        # Fetch latitude and longitude
        latitude = data.get('latitude')
        longitude = data.get('longitude')
        return latitude, longitude
    else:
        return None, None

def fetch_data_and_create_dataframe(document_ids):
    """
    Fetches data from Firestore using document IDs and creates a DataFrame.

    Args:
    document_ids (List[str]): List of document IDs.

    Returns:
    pandas.DataFrame: DataFrame containing fetched data.
    """
    # Initialize an empty list to store the data
    data_list = []

    # Iterate over document IDs
    for doc_id in document_ids:
        # Retrieve document data from food_details collection
        food_details_ref = firestore_db.collection('food_details').document(doc_id)
        food_details_doc = food_details_ref.get()

        if food_details_doc.exists:
            # Access document data
            data = food_details_doc.to_dict()
            # Check if status is "ongoing"
            status = data.get('status')
            if status == "ongoing":
                # Extract restaurant ID
                restaurant_id = data.get('restaurantId')

                # Fetch location using restaurant ID if it exists
                if restaurant_id:
                    latitude, longitude = fetch_location(restaurant_id)
                    if latitude is not None and longitude is not None:
                        # Append data to the list
                        data_list.append({'Food ID': doc_id, 'Latitude': latitude, 'Longitude': longitude, 'Restaurant ID': restaurant_id})
                    else:
                        print(f"Failed to fetch location for Restaurant ID: {restaurant_id}")
                else:
                    print(f"No restaurant ID found for Document ID: {doc_id}")
            else:
                print(f"Skipping Document ID: {doc_id} because status is not 'ongoing'.")
        else:
            print(f"Document with ID {doc_id} does not exist.")

    # Create a DataFrame from the collected data
    df = pd.DataFrame(data_list)
    return df

# Call the function with the document IDs
df_food_details = fetch_data_and_create_dataframe(document_ids)

def update_food_details(food_id, deliverer_id):
    """
    Updates food details with assigned deliverer ID and calculates distance.

    Args:
    food_id (str): ID of the food.
    deliverer_id (str): ID of the deliverer.
    """
    doc_ref = firestore_db.collection('food_details').document(food_id)
    doc_ref.update({
        'status': 'assigned',
        'delivererId': deliverer_id
    })

    # Fetch food details to get food location
    food_details_ref = firestore_db.collection('food_details').document(food_id)
    food_details_doc = food_details_ref.get()
    if food_details_doc.exists:
        data = food_details_doc.to_dict()
        food_lat = data.get('latitude')
        food_lon = data.get('longitude')
    else:
        print(f"Food details not found for Food ID: {food_id}")
        return
    
    # Fetch deliverer location
    deliverer_lat, deliverer_lon = fetch_deliverer_location(deliverer_id)
    if deliverer_lat is None or deliverer_lon is None:
        print(f"Deliverer location not found for Deliverer ID: {deliverer_id}")
        return

    # Check if both latitude and longitude values are not None
    if food_lat is not None and food_lon is not None and deliverer_lat is not None and deliverer_lon is not None:
        # Calculate distance between food and deliverer
        distance = recommender.haversine_distance(deliverer_lat, deliverer_lon, food_lat, food_lon)
        
        # Print debugging information
        print(f"Assigned food {food_id} to deliverer {deliverer_id} (Distance: {distance} km)")
    # Remove the following lines to prevent the message from being printed
    # else:
    #     print(f"Latitude or longitude data is missing for Food ID: {food_id} or Deliverer ID: {deliverer_id}. Cannot calculate distance.")

def fetch_and_update_dataframe():
    """
    Fetches and updates the DataFrame with new data from Firestore.
    """
    # Initialize an empty list to store deliverer data
    deliverer_data = []

    # Function to fetch document IDs from deliverer_details collection
    def fetch_deliverer_detail_document_ids():
        deliverer_details_ref = firestore_db.collection('deliverer_details')
        deliverer_details_docs = deliverer_details_ref.stream()

        document_ids = []
        for doc in deliverer_details_docs:
            document_ids.append(doc.id)

        return document_ids

    # Fetch document IDs from deliverer_details collection
    deliverer_document_ids = fetch_deliverer_detail_document_ids()

    # Iterate over document IDs and fetch latitude, longitude, and deliverer ID for each deliverer
    for deliverer_id in deliverer_document_ids:
        # Retrieve document data from deliverer_details collection
        deliverer_details_ref = firestore_db.collection('deliverer_details').document(deliverer_id)
        deliverer_details_doc = deliverer_details_ref.get()

        if deliverer_details_doc.exists:
            # Access document data
            data = deliverer_details_doc.to_dict()
            # Extract latitude and longitude
            latitude = data.get('latitude')
            longitude = data.get('longitude')
            # Append deliverer data to the list
            deliverer_data.append({'delivererId': deliverer_id, 'Latitude': latitude, 'Longitude': longitude})
        else:
            print(f"Document with ID {deliverer_id} does not exist.")

    # Create a DataFrame from deliverer data
    df_deliverers = pd.DataFrame(deliverer_data)

    # Fetch and create DataFrame for food details
    df_food_details = fetch_data_and_create_dataframe(document_ids)

    # Iterate over food details to assign deliverers
    for _, food_row in df_food_details.iterrows():
        food_id = food_row['Food ID']
        food_lat = food_row['Latitude']
        food_lon = food_row['Longitude']
        
        # Initialize variables for closest deliverer
        min_distance = float('inf')
        closest_deliverer = None

        # Find the closest deliverer to the food item
        for _, deliverer_row in df_deliverers.iterrows():
            deliverer_id = deliverer_row['delivererId']
            deliverer_lat = deliverer_row['Latitude']
            deliverer_lon = deliverer_row['Longitude']
            distance = recommender.haversine_distance(deliverer_lat, deliverer_lon, food_lat, food_lon)

            if distance < min_distance:
                min_distance = distance
                closest_deliverer = deliverer_id
        
        # Check if the closest deliverer is within 10 km
        if min_distance <= 10:
            # Assign food item to the closest deliverer
            update_food_details(food_id, closest_deliverer)
            # Remove the assigned food item from df_food_details DataFrame
            df_food_details.drop(food_row.name, inplace=True)
        else:
            print(f"Food item {food_id} is more than 10 km away and remains unassigned.")

    # Wait for 10 seconds before calling the function again
    time.sleep(10)
    fetch_and_update_dataframe()

# Call the function to start fetching and updating the DataFrame
fetch_and_update_dataframe()
from math import radians, sin, cos, sqrt, atan2

def haversine_distance(lat1, lon1, lat2, lon2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees) using the Haversine formula.

    Args:
    lat1 (float): Latitude of point 1 in decimal degrees.
    lon1 (float): Longitude of point 1 in decimal degrees.
    lat2 (float): Latitude of point 2 in decimal degrees.
    lon2 (float): Longitude of point 2 in decimal degrees.

    Returns:
    float: Distance between the two points in kilometers.
    """
    # Convert latitude and longitude values to float
    lat1, lon1, lat2, lon2 = map(float, [lat1, lon1, lat2, lon2])
    
    # Convert latitude and longitude values to radians
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])
    
    # Calculate haversine distance
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = 6371 * c
    return distance

def recommend_restaurant(df_deliverers, df_food_details, N):
    """
    Recommends a list of restaurants based on the nearest deliverers to food items.

    Args:
    df_deliverers (DataFrame): DataFrame containing deliverer data with columns ['delivererId', 'Latitude', 'Longitude'].
    df_food_details (DataFrame): DataFrame containing food details with columns ['Food ID', 'Latitude', 'Longitude', 'Restaurant ID'].
    N (int): Number of recommendations to return.

    Returns:
    list: List of dictionaries containing recommended food items with keys ['Food ID', 'Distance', 'delivererId'].
    """
    recommendations = []

    for _, food_row in df_food_details.iterrows():
        food_id = food_row['Food ID']
        food_lat = food_row['Latitude']
        food_lon = food_row['Longitude']
        restaurant_id = food_row['Restaurant ID']

        min_distance = float('inf')
        closest_deliverer = None

        # Find the closest deliverer to the food item
        for _, deliverer_row in df_deliverers.iterrows():
            deliverer_id = deliverer_row['delivererId']
            deliverer_lat = deliverer_row['Latitude']
            deliverer_lon = deliverer_row['Longitude']
            distance = haversine_distance(deliverer_lat, deliverer_lon, food_lat, food_lon)

            if distance < min_distance:
                min_distance = distance
                closest_deliverer = deliverer_id

        if closest_deliverer:
            recommendations.append({
                'Food ID': food_id,
                'Distance': min_distance,
                'delivererId': closest_deliverer
            })

    # Sort recommendations by distance
    recommendations.sort(key=lambda x: x['Distance'])

    return recommendations[:N]

# Usage example:
# delivery_lat = df4['latitude_deli'].iloc[8]
# delivery_lon = df4['longitude_deli'].iloc[8]
# recommended_restaurants = recommend_restaurant(delivery_lat, delivery_lon, df4, N=1)
# print(recommended_restaurants)
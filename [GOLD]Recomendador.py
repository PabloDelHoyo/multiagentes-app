import os
import sys
ruta_actual = os.path.dirname(os.path.abspath(sys.argv[0]))
directorio_superior = os.path.dirname(ruta_actual)
abuelo_directorio = os.path.dirname(directorio_superior)
sys.path.append(abuelo_directorio)
from Preprocesado_de_Datos.Acceso_BBDD.MetodosBBDD import *
import pandas as pd
import numpy as np

def prepare_df (df):

    df = df.drop(['AccelSec', 'TopSpeed_KmH', 'Efficiency_WhKm', 'FastCharge_KmH', 
                  'RapidCharge' ,'PowerTrain', 'PlugType', 'BodyStyle', 'Segment'], axis=1)
    print(df)
        
    return df

def TarjetaDeDatos():
    
    nombre_tabla = 'electric_car_data_clean'
    dataframe = obtener_dataframe_sql(nombre_tabla, SILVER)

    data_card = prepare_df(dataframe)
    
    return data_card

dc = TarjetaDeDatos()


# rule based system that acts as an ideal car recommender

# RULE 1: If seats is >= num_seats this rule will be activated and those lines will be selected
num_seats = int(input("Por favor, introduzca el número mínimo de asientos: "))
dc = dc[dc['Seats'] >= num_seats]
print(dc)

# RULE 2: If price is <= budget this rule will be activated and those lines will be selected
budget = int(input("Por favor, introduzca su presupuesto máximo: "))
dc = dc[dc['PriceEuro'] <= budget]
print(dc)

# RULE 3: The rule will be activated if the kms are out of the range
autonomy = int(input("Por favor, introduzca aproximadamente los kms diarios desados: "))
dc = dc[(dc['Range_Km'] >= (autonomy-150)) & (dc['Range_Km'] <= (autonomy+150))]
print(dc)
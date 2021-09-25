import pandas as pd
import json
import matplotlib.pyplot as plt
from scipy import ndimage


biking_file = pd.read_csv('Running.csv', index_col=0, header=0, sep=',')


biking_dataframe = json.loads(pd.DataFrame.to_json(biking_file))
# print(biking_dataframe)
gt_long = []
phone_long = []
gt_lat = []
phone_lat = []
for timestamp in biking_dataframe['gt_lat'].keys():
    gt_long.append(biking_dataframe['gt_long'][timestamp])
    phone_long.append(biking_dataframe['phone_long'][timestamp])
    gt_lat.append(biking_dataframe['gt_lat'][timestamp])
    phone_lat.append(biking_dataframe['phone_lat'][timestamp])

size = len(gt_lat)


def show_raw():
    plt.scatter(phone_long, phone_lat, c=['#12345688']*size, label='phone')
    plt.scatter(gt_long, gt_lat,
                c=['#8c564b88']*size, label='gt')

    plt.xlabel('long')
    plt.ylabel('lat')
    plt.legend()
    plt.title('Running.csv raw')
    plt.show()


def show_median():

    degree = 10
    med_gt_long = ndimage.median_filter(gt_long, size=degree).tolist()
    med_gt_lat = ndimage.median_filter(gt_lat, size=degree).tolist()
    med_phone_long = ndimage.median_filter(phone_long, size=degree).tolist()
    med_phone_lat = ndimage.median_filter(phone_lat, size=degree).tolist()

    plt.scatter(med_phone_long, med_phone_lat, c=[
                '#12345688']*size, label='phone')
    plt.scatter(med_gt_long, med_gt_lat,
                c=['#8c564b88']*size, label='gt')

    plt.xlabel('long')
    plt.ylabel('lat')
    plt.legend()
    plt.title('Running.csv median filter')
    plt.show()


def show_mean():
    degree = 10
    mean_gt_lat = ndimage.uniform_filter(gt_lat, size=degree).tolist()
    mean_gt_long = ndimage.uniform_filter(gt_long, size=degree).tolist()
    mean_phone_lat = ndimage.uniform_filter(phone_lat, size=degree).tolist()
    mean_phone_long = ndimage.uniform_filter(phone_long, size=degree).tolist()

    plt.scatter(mean_phone_long, mean_phone_lat, c=[
                '#12345688']*size, label='phone')
    plt.scatter(mean_gt_long, mean_gt_lat,
                c=['#8c564b88']*size, label='gt')

    plt.xlabel('long')
    plt.ylabel('lat')
    plt.legend()
    plt.title('Running.csv mean filter')
    plt.show()

show_raw()
show_median()
show_mean()

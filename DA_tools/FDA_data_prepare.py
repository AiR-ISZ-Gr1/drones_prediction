from scipy.interpolate import BSpline
import numpy as np
from DA_tools.DA_colors import LIGHT,LIGHT_HIGHLIGHT,MID,MID_HIGHLIGHT,DARK,DARK_HIGHLIGHT

def create_spline_matrix(T, time, spl_order=3, num_knots=10):
    """
    N - Number of time series,
    T - number of samples
    time - array/series of time values

    """
    time = np.array(time)
    knot_list = np.quantile(time, np.linspace(0, 1, num_knots))
    knots = np.pad(knot_list, (spl_order, spl_order), mode="edge")
    B = BSpline(knots, np.identity(num_knots + 2), k=spl_order)(time[0:T])
    # Design matrix
    return B


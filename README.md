# Asteroid light curve simulation and shape reconstruction with Markov Chain Monte Carlo


##2D-Asteroid Light Curve simulation

- Create a shape and save it by running defineShape.m. You can change the shape primarily by changing values of pvec.
  But keep in mind that first 3 values have to be same as last 3 values for curve to be closed. And length of the vector is also important.
  Rules: length(tvec) = length(pvec)+p+1 and length(pvec) = length(wvec)
- Call lightCurve- or lightCurve_visual-function with two parameters:  
    - accuracy: accuracy of the measurement (How many light-rays)
    - angle: angle between viewer's direction and light source
    The difference between these two functions are that lightCurve only produces values of lightcurve, saves them to variable proj_lengths
    and draws the curve. lightCurve_visual also makes an animation from the whole process.
    By uncommenting the code at the end of lightCurve_visual you can also save the animation as AVI-video.
    
Example usage:
  1. Open defineShape.m
  2. Run it
  3. Call a function lightCurve(30, pi/2) or lightCurve_visual(30, pi/2)
  
 ## MCMC simulation
 
 - Simulate MCMC shape reconstruction by running inverse_problem_mcmc.m
 

# Asteroid light curve simulation and shape reconstruction with Markov Chain Monte Carlo


## 2D-Asteroid Light Curve simulation

- Create a shape and save it by running defineShape.m. You can change the shape primarily by changing values of pvec.
  But keep in mind that first 3 values have to be same as last 3 values for curve to be closed. And length of the vector is also important.
  Rules: length(tvec) = length(pvec)+p+1 and length(pvec) = length(wvec)
- Call lightCurve_visual-function with these parameters:  
    - accuracy: accuracy of the measurement (How many light-rays)
    - angle: angle between viewer's direction and light source
    - folder: folder, where animation frames are saved
    
Example usage:
  1. Open defineShape.m
  2. Run it
  3. Create folder 'my_frames'
  4. Call a function lightCurve_visual(30, 3*pi/4, 'my_frames')
  
 ## MCMC simulation
 
 - Simulate MCMC shape reconstruction by running function inverse_problem_mcmc(N, folder, acc, frame_freq)
- parameters:
            - N: number of MCMC iterations
            - folder: folder, where animation frames are saved
            - acc: in light curve simulation, the number of light rays
            - frame_freq: how frequently you want to record a frame 
           (every frame_freq:th iteration will be recorded. In addition frame will
           be recorded whenever new maximum value likelihood occurs)

Example:
  1. Create folder for animation frames ie. 'mcmc_frames'
  2. Run inverse_problem_mcmc(1000, 'mcmc_frames', 10, 1)

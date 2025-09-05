# NeSO
An implementation of paper ["Neural Spline Operators for Risk Quantification in Stochastic Systems"](https://arxiv.org/abs/2508.20288), accepted at the 2025 Conference on Decision and Control (CDC).



## How to Run



### 1D simulation with varying functional dynamics

For FNO training, run [FNO_1D_Varying_Functional.ipynb](https://colab.research.google.com/drive/1LOSEmiBjunzz3XjwdC4NHPXrtobTiDgQ#scrollTo=OH6VufEJtLfo).

For NeSO training, run [NeSO_1D_Varying_Functional.ipynb](https://colab.research.google.com/drive/1Rfv2bEYFg37i3ASG31EVWfTtoKHqaiJF#scrollTo=dd10kyzEsYk6).

For comparison and visualization, run [NeSO_FNO_Comparison.ipynb](https://colab.research.google.com/drive/1tbsUFeRUPIkburaCzZQyjJEl7YLBjH7_#scrollTo=0jgR-HcLorFd).



### 14D multi-agent simulation with varying dynamics and safe sets

For PDE training and testing data generation, run [Data_Generation_Multi_Agent_PDE.ipynb](https://colab.research.google.com/drive/1REkCqoTgHS1QwIoy8z9Fj2jEc17qMR2b#scrollTo=ZPcNn0vTH4pz). Save the data under  `data/multi_agent/PDE/`

For NeSO training and testing, run [NeSO_Multi_Agent.ipynb](https://colab.research.google.com/drive/1m99rD_SaqXKkriYbatCooNu_DyjycaIb#scrollTo=ck0J1Fk6V36_). Save the data under  `data/multi_agent/NeSO/`

For MC testing data generation, run `StateTrajectories_MC.m` to generate state trajectories, and then run  `Calc_SafeProb_by_MCdata.m` to calculate the safety probabilities based on the trajectory data.

For visualization of NeSO vs. MC, run  `Visualize_comparison_between_MC_and_NeSO.m`.


### Data and Trained Models

Pre-collected data and pre-trained models can be downloaded from [here](https://drive.google.com/drive/folders/1MBE8mpl3pgpOk0WWou3IZtSALisxwyTY?usp=drive_link).

**Note:** remember to change the path while loading trained models.


## Acknowledgement

The PDE solver and Monte Carlo simulation are adapted from the simulation in the paper ["Orthogonal Modal Representation in Long-Term Risk Quantification for Dynamic Multi-Agent Systems"](https://ieeexplore.ieee.org/document/10816487). We appreciate the authors for sharing their code with us.


## Citation

If you find our work helpful, please consider citing our paper.

```
@article{wang2025neural,
  title={Neural Spline Operators for Risk Quantification in Stochastic Systems},
  author={Wang, Zhuoyuan and Romagnoli, Raffaele and Azizzadenesheli, Kamyar and Nakahira, Yorie},
  journal={arXiv preprint arXiv:2508.20288},
  year={2025}
}
```





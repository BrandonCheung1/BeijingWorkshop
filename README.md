# BeijingWorkshop
2023北京基因组选择研讨会assignment

一、数据收集
1.数据来源于文章公开数据《Genome-Wide Association Study Reveals Candidate Genes for Growth Relevant Traits in Pigs》 Z Tang et al. DOI: 10.3389/fgene.2019.00302
2.数据包含猪60K基因组芯片以及两组表型值（ADG和AGE），数据个体为4200

二、数据分析
1.利用5-folds交叉验证，通过GBLUP模型分别对两组表型进行基因组预测；
2.利用5-folds交叉验证，先通过MLM模型分别对两组模型进行GWAS分析，选取超过suggestive threshold的显著位点作为QTN，再把QTN作为固定效应，通过GBLUP模型分别对两组表型进行基因组预测；
3.比较两种基因组预测的准确性大小

三、结果
1.利用GWAS+GS的方法进行预测，其平均准确性高于单独GS
2.利用GWAS+GS的方法进行预测，其准确性分布更集中

四、结论
1.借助QTN位点的效应，GS在这两组表型中的预测准确性得到提升

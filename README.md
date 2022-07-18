# CogVideo-lamda
This repo makes small modifications to the original CogVideo project to make it straightforward to run this model on [Lambda](https://lambdalabs.com/), an affordable cloud provider.

This instructions are meant to get you up and running as fast as possible so you can create videos using the minimum amount of GPU time.

## Instructions
### Set up Lambda
[Sign up](https://lambdalabs.com/cloud/entrance) to Lambda. Fill your information, complete the email verification and add a credit card.

Press the "Launch instance" button and introduce your public ssh key. Your public key should be on the folder in `~/.ssh/` in a file named `id_rsa.pub`. You can see its content with `cat ~/.ssh/id_rsa.pub`. Copy and paste the result to lambda and you'll be set. If you do not find anything on this folder that means you do not have an ssh public key. [Here](https://docs.oracle.com/en/cloud/cloud-at-customer/occ-get-started/generate-ssh-key-pair.html)'s the process to generate one.

Once the instance is launched, wait for a minute or two until the Status of the machine says "Running". Then, copy the line under "SSH LOGIN" that looks like: `ssh ubuntu@<ip-address>`, where your `<ip-address>` will be a series of numbers in the form `123.456.789.012`. Paste it on your terminal, type "yes" to the prompt that will appear and you'll be in your new machine with an A100!

### Write down your prompts
Once you have accessed the machine, edit the file `one-prompt-per-line.txt` and write in different lines the texts that you want to use for each your generations. The text needs to be in simplified chinese. You can use `nano texts.txt` and paste in different lines the texts that you want to use. Once you've finished exit nano with `CTRL + X`, press `y` to save the changes and then press `ENTER` to write the new file. Here's an example of what the file can look like: 

```
3 架机械金属飞马在一个有很多人注视着他们的城市中疾驰而过，在一个暴风雨的夜晚，闪电穿过云层。
两个忍者战斗
一只巨大的玉米哥斯拉跺着纽约市
一个女孩跑向地平线。
```

This file would generate 4 videos.

### Generate!
Now, we will use simple tmux commands. Tmux will allow us to have multiple terminal sessions running at the same time that can keep running on the background even if we leave the machine. Read more about it [here](https://github.com/tmux/tmux/wiki).

The first command will start a new terminal called "cog". Run `tmux new -s cog` and you'll be automatically inside a new terminal. Once inside, just run `bash install-download-and-run.sh`. Surprise surprise, this wil install the required dependencies, download the CogVideo models and run them. This will take around 25-30 minutes, the models are large!

You can detach from the terminal pressing `CTRL + B` and then `D` (mac users: use CONTROL, not COMMAND) at anytime (make sure not to close the terminal, do not type `CTRL + D`). After detaching, you'll be back to the terminal of your Lambda instance. You can leave this instance and the tmux terminal will keep running. Once you access the Lambda instance again, you can access the "cog" tmux terminal session with the command `tmux a -t cog` and see how the generations are going. 

### Import results to your local computer
Run the following command from your local terminal: `rsync -chavzP --stats ubuntu@<lambda-instance-ip>:/home/ubuntu/CogVideo-lambda/output ./`. Your `<lambda-instane-ip>` will be a series of numbers like `123.456.789.012`.

This will create a folder named `output` in the directory from where you ran the command. Inside you'll find all your generations!

### Terminate your Lambda instance
Make sure to terminate your lambda instance once you're finished!

## Doubts?
Feel free to open an issue to this repo with any problem you encounter so we can improve the installation script.

Have fun!
-@viccpoes

# CogVideo

This is the official repo for the paper: [CogVideo: Large-scale Pretraining for Text-to-Video Generation via Transformers](http://arxiv.org/abs/2205.15868).

**News!** The [demo](https://wudao.aminer.cn/cogvideo/) for CogVideo is available! 

**News!** The code and model for text-to-video generation is now available! Currently we only supports *simplified Chinese input*. 

https://user-images.githubusercontent.com/48993524/170857367-2033c514-3c9f-4297-876f-2468592a254b.mp4

* **Read** our paper [CogVideo: Large-scale Pretraining for Text-to-Video Generation via Transformers](https://arxiv.org/abs/2205.15868) on ArXiv for a formal introduction. 
* **Try** our demo at [https://wudao.aminer.cn/cogvideo/](https://wudao.aminer.cn/cogvideo/)
* **Run** our pretrained models for text-to-video generation. Please use A100 GPU.
* **Cite** our paper if you find our work helpful

```
@article{hong2022cogvideo,
  title={CogVideo: Large-scale Pretraining for Text-to-Video Generation via Transformers},
  author={Hong, Wenyi and Ding, Ming and Zheng, Wendi and Liu, Xinghan and Tang, Jie},
  journal={arXiv preprint arXiv:2205.15868},
  year={2022}
}
```

## Web Demo

The demo for CogVideo is at [https://wudao.aminer.cn/cogvideo/](https://wudao.aminer.cn/cogvideo/), where you can get hands-on practice on text-to-video generation. *The original input is in Chinese.*


## Generated Samples

**Video samples generated by CogVideo**. The actual text inputs are in Chinese. Each sample is a 4-second clip of 32 frames, and here we sample 9 frames uniformly for display purposes.

![Intro images](assets/intro-image.png)

![More samples](assets/appendix-moresamples.png)



**CogVideo is able to generate relatively high-frame-rate videos.**
A 4-second clip of 32 frames is shown below. 

![High-frame-rate sample](assets/appendix-sample-highframerate.png)

## Getting Started

### Setup

* Hardware: Linux servers with Nvidia A100s are recommended, but it is also okay to run the pretrained models with smaller `--max-inference-batch-size` and `--batch-size` or training smaller models on less powerful GPUs.
* Environment: install dependencies via `pip install -r requirements.txt`. 
* LocalAttention: Make sure you have CUDA installed and compile the local attention kernel.

```shell
git clone https://github.com/Sleepychord/Image-Local-Attention
cd Image-Local-Attention && python setup.py install
```

### Download

Our code will automatically download or detect the models into the path defined by environment variable `SAT_HOME`. You can also manually download [CogVideo-Stage1](https://lfs.aminer.cn/misc/cogvideo/cogvideo-stage1.zip) and [CogVideo-Stage2](https://lfs.aminer.cn/misc/cogvideo/cogvideo-stage2.zip) and place them under SAT_HOME (with folders named `cogvideo-stage1` and `cogvideo-stage2`)

### Text-to-Video Generation

```
./scripts/inference_cogvideo_pipeline.sh
```

Arguments useful in inference are mainly:

* `--input-source [path or "interactive"]`. The path of the input file with one query per line. A CLI would be launched when using "interactive".
* `--output-path [path]`. The folder containing the results.
* `--batch-size [int]`. The number of samples will be generated per query.
* `--max-inference-batch-size [int]`. Maximum batch size per forward. Reduce it if OOM. 
* `--stage1-max-inference-batch-size [int]` Maximum batch size per forward in Stage 1. Reduce it if OOM. 
* `--both-stages`. Run both stage1 and stage2 sequentially. 
* `--use-guidance-stage1` Use classifier-free guidance in stage1, which is strongly suggested to get better results. 

You'd better specify an environment variable `SAT_HOME` to specify the path to store the downloaded model.

*Currently only Chinese input is supported.*

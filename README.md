# RunJModelica

これは、JModelicaを利用してFMUファイルを作成し、PyFMIを利用してCo-Simulationを実施するための環境構築と実行例を示すレポジトリです。

### 事前準備：Docker Imageの作成（省略してOK）

- Dockerfileは作成していないが、この[ページ](https://www.amane.to/archives/710)に従ってImageを作成する
- こちらで作成したImageをDockerHubの[taiga4112/jmodelica:jm0](https://hub.docker.com/repository/docker/taiga4112/jmodelica)にPushしているので、以降ではこのイメージを使う前提で説明する
  - 本来は、JModelicaの登録が必要みたいなので、これはあくまでお試し用ということでご理解ください

## `scripts/create_fmu_from_jmodelica.py`を利用してmoファイルからFMUファイルを作成する例

前提として、`scripts/mo_file`フォルダにコンパイル対象となるmoファイルを置いてある状態を想定する。ここでは、mo_fileの直下にKT_3DOF.moファイルを置いたものとする

### IPython環境を利用する場合

1. DockerHubにある[taiga4112/jmodelica:jm0](https://hub.docker.com/repository/docker/taiga4112/jmodelica)のイメージを利用して、以下のコマンドでipythonを起動する

  ```sh
  $ docker pull taiga4112/jmodelica:jm0
  $ docker run --rm --name create_fmu_from_jmodelica -it \
    -v $(pwd)/scripts:/home/jmodelica/jmodelica -w /home/jmodelica/jmodelica \
    taiga4112/jmodelica:jm0 /usr/local/jmodelica/bin/jm_ipython.sh
  ```

2. IPython上で以下のコマンドで`KT_3DOF.fmu`ファイルを作成する
  
  ```sh
  %run create_fmu_from_jmodelica.py mo_file/KT_3DOF.mo KT_3DOF
  ```

### Python環境を利用する場合

1. DockerHubにある[taiga4112/jmodelica:jm0](https://hub.docker.com/repository/docker/taiga4112/jmodelica)のイメージを利用して、以下のコマンドでpythonを起動する

  ```sh
  $ docker pull taiga4112/jmodelica:jm0
  $ docker run --rm --name create_fmu_from_jmodelica -it \
    -v $(pwd)/scripts:/home/jmodelica/jmodelica -w /home/jmodelica/jmodelica \
    taiga4112/jmodelica:jm0 /usr/local/jmodelica/bin/jm_python.sh
  ```

2. IPython上で以下のコマンドで`KT_3DOF.fmu`ファイルを作成する
  
  ```python
  >>> import create_fmu_from_jmodelica as cj
  >>> cj.create_fmu_from_jmodelica("mo_file/KT_3DOF.mo", "KT_3DOF")
  ```



## Jupyter上でFMU作成とCo-Simulationを実行する例

- DockerHubにある[taiga4112/jmodelica:jm0](https://hub.docker.com/repository/docker/taiga4112/jmodelica)のイメージを利用して、以下のコマンドでJupyterを起動する

  ```sh
  $ docker pull taiga4112/jmodelica:jm0
  $ docker run -it --rm --name ktjm -p 8888:8888 \
      -u root -v $(pwd)/notebooks:/home/jmodelica/jmodelica \
      taiga4112/jmodelica:jm0 /usr/local/jmodelica/bin/jm_start.sh
  ```

- その後、[http://localhost:8888](http://localhost:8888)にアクセスする
  - Access Tokenは`jmodelica`です


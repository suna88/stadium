<template>
  <div class="container">
    <h1 class="theme">Admin Page</h1>
    <div v-if="step == 3" class="done">
      アップロード完了
    </div>
    <div v-if="step == 2" class="mask">
      アップロード中...
    </div>
    <div v-if="step == 0" class="writing">
      <div class="title">
        <h3>記事タイトル</h3>
        <input v-model="title">
      </div>
      <div class="author">
        <h3>記者名</h3>
        <input v-model="author">
      </div>
      <div class="eye-catch">
        <h3>アイキャッチ画像</h3>
        <input @change="setImg" type="file" accept="image/*">
        <img :src="eyecatchImgPreview" v-if="eyecatchImgPreview">
      </div>
      <div class="content-area">
        <h3>記事本文</h3>
        <textarea v-model="content" wrap="hard"></textarea>
      </div>
      <button v-if="isEmpty" class="button disabled" disabled>確認する</button>
      <button v-if="!isEmpty" class="button" @click="addStep">確認する</button>
    </div>
    <div v-if="step == 1" class="confirm">
      <div class="title">
        <h3>記事タイトル</h3>
        <div>{{title}}</div>
      </div>
      <div class="author">
        <h3>記者名</h3>
        <div>{{author}}</div>
      </div>
      <div class="eye-catch">
        <h3>アイキャッチ画像</h3>
        <img :src="eyecatchImgPreview" v-if="eyecatchImgPreview">
      </div>
      <div class="content-area">
        <h3>記事本文</h3>
        <div>{{content}}</div>
      </div>
      <button class="button" @click="reEdit">編集画面に戻る</button>
      <button class="button" @click="submit">送信する</button>
    </div>
  </div>
</template>

<style scoped lang="scss">
  .container {
    > div > div:nth-child(-n+3){
      text-align: center;
      margin: 0 20% auto ;
      padding-top: 10px;
      padding-bottom: 40px;
      border-bottom: 1px lightgray solid;
    }
    .theme {
      margin: 0 40% auto;
    }

  }
  .done {
    position: absolute;
    top:0;
    left:0;
    text-align: center;
    padding-top: 400px;
    width: 100%;
    height: 80%;
    background-color: dodgerblue;
    opacity: 0.8;
    color: white;
    font-size: 32px;
  }

  .mask {
    position: absolute;
    top:0;
    left:0;
    text-align: center;
    padding-top: 400px;
    width: 100%;
    height: 80%;
    background-color: rgba(20, 100, 20, 0.8);
    color: white;
    font-size: 32px;
  }

  .title {
    input {
      width: 80%;
      height: 50px;
      font-size: 14px;
    }
  }

  .author {
  }

  .eye-catch {
    input {
      margin-bottom: 20px;
    }
    img {
      border-radius: 1px;
      border: 1px solid lightgray;
      margin: auto;
      display: block;
      width: 300px;
      height: 200px;
    }
  }

  .content-area {
    margin: 20px 20%;
    textarea {
      width: 100%;
      height: 750px;
      font-size: 14px;
      padding: 10px;
    }
    div{
      padding: 20px;
      border: 1px lightgray solid;
      text-align: left;
      white-space: pre-wrap;
    }
  }

  .button {
    width: 30%;
    height: 50px;
    font-size: 20px;
    background-color: #008800;
    color: white;
    border-radius: 10px;
  }

  .disabled {
    background-color: lightgray;
  }

</style>

<script>
/* eslint-disable no-trailing-spaces,indent */
  import firebase from 'firebase'

  export default {
    name: 'Top',
    data: function () {
      return {
        msg: 'Welcome to Your Vue.js App',
        database: null,
        ref: null,
        imgRef: null,
        storageRef: null,
        articleId: null,
        author: null,
        title: null,
        content: null,
        step: 0,
        test: 'testImg',
        eyecatchImgFile: null,
        eyecatchImgPreview: null
      }
    },
    created: function () {
      this.database = firebase.database()
      this.ref = this.database.ref('articles')
      this.ref.once('value').then((snapshot) => {
          var ids = []
          for (let key in snapshot.val()) {
            if (snapshot.val()[key].id) {
              ids.push(snapshot.val()[key].id)
            }
          }
          this.articleId = Math.max.apply(null, ids) + 1
          console.log(this.articleId)
        }
      )
      this.storageRef = firebase.storage().ref()
    },
    methods: {
      addStep: function () {
        this.step += 1
      },
      submit: function () {
        this.addStep()
        this.ref.push({
          'title': this.title,
          'author': this.author,
          'content': this.content,
          'id': this.articleId
        })
        this.postImg()
      },
      setImg: function (e) {
        e.preventDefault()
        const files = e.target.files
        if (files.length > 0) {
          this.eyecatchImgFile = files[0]
          const reader = new FileReader()
          reader.onload = (e) => {
            this.eyecatchImgPreview = e.target.result
          }
          reader.readAsDataURL(this.eyecatchImgFile)
        }
      },
      postImg: function () {
        this.imgRef = this.storageRef.child(`articles/${this.articleId}/${this.articleId}_bg.jpg`)
        this.imgRef.put(this.eyecatchImgFile)
          .then((snapshot) => {
            console.log(snapshot)
            this.addStep()
            setTimeout(() => { this.$router.go({ name: 'Top' }) }, 3000)
          })
          .catch((e) => {
            console.log('error_____________________________')
            console.log(e)
          })
      },
      reEdit: function () {
        this.step -= 1
        this.eyecatchImgPreview = null
        this.eyecatchImgFile = null
      }
    },
    computed: {
      isEmpty: function () {
        return !(this.title && this.author && this.content && this.eyecatchImgFile)
      }
    }
  }
</script>

<template>
  <div>
    <h1>Admin Page</h1>
    <div v-if="done" class="done">
      アップロード完了
    </div>
    <div v-if="mask" class="mask">
      アップロード中...
    </div>
    <div v-if="isWriting" class="writing">
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
        <textarea v-model="content"></textarea>
      </div>
      <button v-if="isEmpty" class="button disabled" disabled>確認する</button>
      <button v-if="!isEmpty" class="button" @click="confirm">確認する</button>
    </div>
    <div v-if="!isWriting" class="confirm">
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
  }
  .done {
    text-align: center;
    padding-top: 400px;
    width: 100%;
    height: 1000px;
    background-color: dodgerblue;
    opacity: 0.8;
    color: white;
    font-size: 32px;
  }

  .mask {
    text-align: center;
    padding-top: 400px;
    width: 100%;
    height: 1000px;
    background-color: rgba(20, 100, 20, 0.8);
    color: white;
    font-size: 32px;
  }

  .title {
    input {
      width: 80%;
      height: 50px;
      font-size: 18px;
    }
  }

  .eye-catch {
    input {
      margin-bottom: 20px;
    }
    img {
      border-radius: 1px;
      border: 1px solid gray;
      margin: auto;
      display: block;
      width: 300px;
      height: 200px;
    }
  }

  .content-area {
    margin: 20px 10%;
    textarea {
      width: 100%;
      height: 500px;
      font-size: 18px;
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
  import axios from 'axios'

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
        isWriting: true,
        test: 'testImg',
        eyecatchImgFile: null,
        eyecatchImgPreview: null,
        mask: false,
        done: false
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
      confirm: function () {
        this.isWriting = false
      },
      submit: function () {
        this.mask = true
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
            this.mask = false
            this.done = true
            setTimeout(() => { this.$router.go({ name: 'Top' }) }, 3000)
          })
          .catch((e) => {
            console.log('error_____________________________')
            console.log(e)
          })
      },
      reEdit: function () {
        this.isWriting = true
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

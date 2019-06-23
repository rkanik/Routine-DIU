<template>
    <div class="Signin">
        <div class="container">
            <div class="card">
                <h4 class="text-center card-title grey-7">Sign in with your Email and Password</h4>
                <hr class="br-grey-3">
                <form>
                    <div class="form-group">
                    <label for="email">Authorised Email</label>
                    <input type="email" v-model="email" class="form-control" name="email" id="email" aria-describedby="emailHelpId" placeholder="Enter admin email address">
                    <small id="emailHelpId" class="form-text text-muted">{{emailMassage}}</small>
                    </div>
                    <div class="form-group">
                    <label for="pass">Password</label>
                    <input type="password" v-model="pass" class="form-control" name="pass" id="pass" placeholder="Enter your password">
                    </div>
                    <input @click="SignIn()" class="btn btn-primary btn-sm" type="button" value="SIGNIN">
                </form>
            </div>
        </div>
    </div>
</template>
<script>

/** IMPORTS */
import firebase from 'firebase/app';
import 'firebase/auth';
const auth = firebase.auth();
import { bus } from '../../main';

export default {
    name:'Signin',
    data(){
        return{
            email:'',
            pass:'',
            emailMassage:''
        }
    },
    created(){},
    methods:{
        SignIn(){
            auth.signInWithEmailAndPassword(this.email,this.pass)
            .then(()=> {
                bus.$emit('SignedIn');
            })
            .catch( error => {
                this.emailMassage = error.message;
            })
        }
    }
}
</script>
<style lang="scss" scoped>
    .card{
        width: 24rem;
        margin: 0 auto;
        display: block;
        padding: 2rem;
        position: absolute;
        top: 50%;left: 50%;
        transform: translate(-50%,-50%);
        .btn{
            display: block;
            margin: 0 auto;
            padding-left: 3rem;
            padding-right: 3rem;
        }
        label{
            color: #616161;
        }
    }
</style>

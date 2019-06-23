<template>
    <div id="Settings">
        <div class="set-group" v-bind:class="{'light-colors':lightTheme}">
            <label class="text-accent">Theme</label><br>
            <button type="button" @click="FixTheme(true)" class="btn" v-bind:class="{'btn-outline-dark':!lightTheme,'btn-info':lightTheme}">Light</button>
            <button type="button" @click="FixTheme(false)" class="ml-3 btn"  v-bind:class="{'btn-outline-dark':lightTheme,'btn-info':!lightTheme}">Dark</button>
        </div>
        <div class="set-group" v-bind:class="{'light-colors':lightTheme}">
            <label class='text-accent'>Time Displaying</label><br>
            <form>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="timimg" id="normal" value="normal" checked>
                    <label class="form-check-label" for="normal">
                        Normal
                    </label>
                    </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="timimg" id="ramadan" value="ramadan" disabled>
                    <label class="form-check-label" for="ramadan">
                        Ramadan
                    </label>
                </div>
            </form>
        </div>
        <div class="set-group" v-bind:class="{'light-colors':lightTheme}">
            <label class="text-accent">View Option</label><br>
            <div class="row">
                <div class="tab-view col-md-4" v-bind:class="{active:tabActive==='Tab'}">
                    <img src="../assets/images/tab-view.png" @click="setSelectedViewType('Tab')">
                    <p>CARD VIEW</p>
                </div>
                <div class="tab-view col-md-4" v-bind:class="{active:tabActive==='Table'}">
                    <img src="../assets/images/table-view.png" @click="setSelectedViewType('Table')">
                    <p>TABLE VIEW</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>

/** IMPORTS **/
import { bus } from "../main";

export default {
    name:'Settings',
    components:{},
    data(){return{
        tabActive:'Table',
        lightTheme:true,
    }},
    created(){
        this.fetchSelectedViewType();
        this.FetchTheme();

    },
    mounted(){},
    methods:{
        OnTimeFunctionChange(x){
            //console.log(x);
            localStorage.setItem('Timing',x);
            bus.$emit('SettingChanged','Timing');
        },
        setSelectedViewType(x){
            this.tabActive = x;
            localStorage.setItem('ViewType',x)
            bus.$emit('SettingChanged','ViewType');
        },
        fetchSelectedViewType(){
            if(localStorage.getItem('ViewType')){
                this.tabActive = localStorage.getItem('ViewType');
            }
        },
        FixTheme(x){
            this.lightTheme=x;
            bus.$emit('ThemeChanged',x);
            localStorage.setItem('Theme',x);
        },
        FetchTheme(){
            if(localStorage.getItem('Theme')!==undefined){
                if(localStorage.getItem('Theme')==='true'){
                this.FixTheme(true)}else{this.FixTheme(false);}   
            }else{this.FixTheme(false)}
        }
    }
}
</script>

<style lang="scss" scoped>
#Settings{
    padding: 1rem 0;
    width: 44rem;
    margin: 0 auto;
}
.set-group{
    padding: 1rem;
    border: 1px solid #191919;
    background-color: #191919;
    margin-bottom: 1rem;
}
.tab-view {
    position: relative;
    border: 1px solid #212121;
    cursor: pointer;
    overflow: hidden;
    border-radius: 4px;
    margin-left: 1rem;
    padding: 0;
    img{
        height: 100%;width: 100%;
        transition: transform 0.3s ease-in-out;
    }
    p{
        position: absolute;
        bottom: 0; left: 1rem;
        z-index: 100;
        color: white;
    }
    
}
.tab-view img:hover{
    transform: scale(1.2);
}
.active{
    border-color: #009688;
}
// THEAMIG //
.light-colors{
    background-color: #fafafa;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.1);
    border: none;
}
</style>

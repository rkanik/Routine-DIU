<template>
    <div id="Admin">
        <Loader2 v-if="loading"/>
        <Signin v-if="isSignedIn===false"/>
        <div v-if="isSignedIn">
            <div class="jumbotron jumbotron-fluid text-center">
                <div class="container">
                    <h1 class="display-4 grey-8">DIU Routine Manager CSE</h1>
                    <p class="lead grey-7">Admin Panel</p>
                    <hr class="my-2">
                    <div class="btn-group" role="group" aria-label="Basic example">
                        <button @click="OnClickStudents()" type="button" class="btn btn-outline-info">Students</button>
                        <button @click="LogoutAdmin()" type="button" class="btn btn-outline-danger">Logout</button>
                        <button @click="ReformatRoutine()" type="button" class="btn btn-outline-info" disabled>Format Routine</button>
                        <button @click="UploadRoutine()" type="button" class="btn btn-outline-info" disabled>Upload Routine</button>
                    </div>
                </div>
                
                <div class="input-group mb-3 mt-3 w-50">
                    <div class="input-group-prepend">
                        <span class="input-group-text" id="inputGroupFileAddon01">Upload</span>
                    </div>
                    <div class="custom-file">
                        <input @change="OnFileSelected" type="file" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
                        <label class="custom-file-label" for="inputGroupFile01">Choose file</label>
                    </div>
                </div>

            </div>

            <div class="components">
                <Students v-if="showStudents" v-bind:Students="Students"/>
            </div>
        </div>
    </div>
</template>

<script>

/** IMPORTS */


/** COMPONENTS */

export default {
    name:'',
    props:{

    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */

            /** Objects */

            /** Arrays */

            /** Strings */
        }
    },
    created(){

    },
    methods:{

    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
    // .per-box{
    //     .per-base{
    //         position: relative;
    //         height: 0.2rem;overflow: visible;
    //         background-color: #262626;
    //         .per-line{
    //             width: 50%;display: block;
    //             height: 100%;position: relative;
    //             background-color: #2196f3;
    //             overflow: visible;
    //             .per-circle{
    //                 position: absolute;
    //                 top: -0.45rem;right: -0.45rem;border-radius: 50%;
    //                 height: 1.2rem;width: 1.2rem;
    //                 background-color: white;
    //                 .per-text{
    //                     color: black;
    //                     font-weight: 100;
    //                     font-size: 0.5em;
    //                     position: absolute;
    //                     top: 50%;left: 50%;
    //                     transform: translate(-50%,-50%);
    //                 }
    //             }
    //         }
    //     }
</style>

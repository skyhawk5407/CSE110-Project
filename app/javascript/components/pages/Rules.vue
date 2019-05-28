<style scoped>
    body {
        background-color: #e2e2e2;
    }

</style>


<template>

    <div>
        <b-jumbotron>
            <template slot="header">
				Rules
			</template>
        <b-card>
            <p v-html="htmlForEditor" id="text" @change="changeText"></p>
        </b-card>
        <b-row class="p-3 my-1" align-h="center">
            <input type="file" ref="file" style="display: none" @change="onFileChange" ><br>
            <b-button class="btn btn-primary btn-lg" @click="$refs.file.click()">Upload Rules</b-button>
        </b-row>
        <b-row class="p-3 my-1" align-h="center">
            <b-card>
                <vue-editor placeholder="Edit Rules Here" v-model="htmlForEditor" id="editor"></vue-editor>
            </b-card>
        </b-row>
        </b-jumbotron>
    </div>
</template>

<script>
    import { VueEditor } from 'vue2-editor'

    export default {
        name: 'Rules',

        components: {
            VueEditor
        },

        data() {
            return {
                url: '<h1>Some initial content</h1>',
                htmlForEditor: null
            }
        },
        methods: {
            onFileChange(e) {
                const file = e.target.files[0];
                var input = event.target;
                // this.url = URL.createObjectURL(file);
                var reader = new FileReader();

                reader.onload = function(){
                    var text = reader.result;
                };
                reader.readAsText(file);
            },
            changeText() {
                this.htmlForEditor = '<h1>Some</h1>';
            }
        }
    }

</script>

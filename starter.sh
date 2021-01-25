cd $1
mkdir -p public/scripts src
npm init -y
json -I -f package.json -e 'this.scripts={"start": "webpack serve --open --mode development", "build": "webpack --mode production"}'
npm install babel-loader @babel/core @babel/preset-env webpack webpack-cli webpack-dev-server @babel/plugin-transform-runtime @babel/runtime sass-loader sass css-loader style-loader
cat <<EOT >> webpack.config.js
const path = require('path')
module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'public/scripts'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.m?js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [['@babel/preset-env', { targets: "defaults" }]],
                        plugins: ['@babel/transform-runtime']
                    }
                }
            }, 
            {
                test: /\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "sass-loader",
                ],
            },
        ]
    }, 
    devServer: {
        contentBase: path.resolve(__dirname, 'public'), 
        publicPath: '/scripts/', 
	watchContentBase: true
    }, 
    devtool: 'source-map'
}
EOT
cat <<EOT >> public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starter Page</title>
</head>
<body>
    <h1>Starter Page</h1>
    <script src="scripts/bundle.js"></script>
</body>
</html>
EOT
echo "import './style.scss'" >> src/index.js
cat << EOT >> src/style.scss
@import url('https://fonts.googleapis.com/css?family=Muli&display=swap');
\$testcolor: orange;
* {
    box-sizing: border-box;
}
body {
    background-color: \$testcolor;
    font-family: 'Muli', sans-serif;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh;
    overflow:hidden;
    margin: 0;
}
EOT
npm run build
npm run start

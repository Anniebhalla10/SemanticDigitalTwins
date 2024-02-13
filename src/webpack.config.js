const path = require("path")
const HtmlWebpackPlugin = require("html-webpack-plugin")
const webpack = require('webpack')

module.exports = {
    mode: "development",
    entry: {
        bundle: path.resolve(__dirname, 'index.js')
    },
    output: {
        path: path.resolve(__dirname, "dist/javascript"),
        filename: '[name].js',
        clean: true,
    },
    devServer: {
        static: {
            directory: path.resolve(__dirname, "./dist"),
        },
        port: 3000,
        open: true,
        hot: true,
        compress: true,
        historyApiFallback: true,
    },
    resolve: {
        fallback: { crypto: false },
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: "Webpack App",
            filename: "index.html",
            template: "../views/index.erb",
        }),
        new webpack.ProvidePlugin({
            process: 'process/browser',
        }),
    ],
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: ["style-loader", "css-loader"],

            },
            {
                test: /\.ttl$/,
                use: [
                    {
                        loader: 'file-loader',
                    }
                ]
            },
            {
                test: /\.ifc$/,
                use: [
                    {
                        loader: 'file-loader',
                    }
                ]
            },
            {
                test: /\.m?js/,
                resolve: {
                    fullySpecified: false,
                },
            },
        ]
    },
}
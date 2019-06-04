var configs = {
    theme: {
        "primary_color": "#00b4f9",
        "secondary_color": "#0092cc"
    },
    jobs: [
        // {
        //     "title": "Example title",
        //     "shortDescription": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam semper diam at erat pulvina", // Max 90 characters
        //     "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam semper diam at erat pulvina",
        //     "group": "exampleRole",
        //     "whitelisted": true,
        //     requirements: ["Example requirement"]
        // },
        // Whitelisted jobs
        {
            "title": "Police",
            "shortDescription": "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod",
            "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation",
            "group": "",
            "whitelisted": true,
            "iconName": "police.jpg",
            requirements: ["Lorem ipsum dolor sit amet", "consectetur adipiscing elit", "sed do eiusmod"]
        },
        // Unwhitelisted jobs
        {
            "title": "Taxi",
            "shortDescription": "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod",
            "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud exercitation",
            "group": "taxi",
            "whitelisted": false,
            "iconName": "taxi.png",
            requirements: ["Lorem ipsum dolor sit amet", "consectetur adipiscing elit", "sed do eiusmod"]
        }
    ]
}
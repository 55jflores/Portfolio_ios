@app.route('/test/<sl>/<sw>/<pl>/<pw>')
def return_flower(sl,sw,pl,pw):
   
    iris_measurements = [sl,sw,pl,pw]

    iris_model = load_model('iris_model_v1.h5')
    iris_scaler = joblib.load('iris_scaler_v1.pkl')
    
    prediction, win_dec = predict_measurements(iris_model,iris_scaler,iris_measurements)
    

    format_prob = float(round(win_dec * 100,2))
    answer = {"results":{
                "winningname":prediction,
                "winningprob":format_prob
                }
            }
            
    return jsonify(answer)

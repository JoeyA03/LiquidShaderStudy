using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LiquidPouring : MonoBehaviour
{
    public GameObject bottle;
    public GameObject streamPrefab;
    public Transform origin;

    private bool isPouring = false;
    private Stream currentStream = null;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        bool pourCheck = Vector3.Dot(bottle.transform.up, Vector3.up) < 0.2;
        if(isPouring != pourCheck)
        {
            isPouring = pourCheck;

            if(isPouring)
            {
                startPour();

            }else
            {
                endPour();  

            }
            
        }   

    }

    private void startPour()
    {
        Debug.Log("Pouring");
        currentStream = CreateStream();
        currentStream.Begin();
    }

    private void endPour()
    {
        Debug.Log("Not Pouring");
        currentStream.DesotryStream();
    }

    // private void calcPourAngle()
    // {
    //     return transform.forward.y * Mathf.Rad2Deg;
    // }

    private Stream CreateStream()
    {
        GameObject streamObject = Instantiate(streamPrefab, origin.position, Quaternion.identity, transform);
        return streamObject.GetComponent<Stream>();

    }



}

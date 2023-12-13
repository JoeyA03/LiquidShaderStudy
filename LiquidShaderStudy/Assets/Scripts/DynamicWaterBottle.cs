using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DynamicWaterBottle : MonoBehaviour
{
    public GameObject bottle;
    public GameObject plane;
    public Material liquid;

    public Vector3 offset;
    public float bottleHeight;

    public Transform bottomBottle;
    public Transform topBottle;


    Vector3 normal;
    Vector3 pos;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        pos = plane.transform.position;
        normal = plane.transform.up;


        

        Vector3 planePos = bottle.transform.position + offset;

        Vector3 a = bottle.transform.position;
        Vector3 b = bottle.transform.position + transform.TransformDirection(Vector3.up) * bottleHeight;



        Debug.Log(Vector3.Dot(bottle.transform.up, Vector3.up));

        // if(Vector3.Dot(bottle.transform.up, Vector3.up) > 0)
        // {
        //     plane.transform.position = (bottomBottle.position + bottomBottle.up) + offset;
        // }else
        // {
        //     plane.transform.position = (topBottle.position - topBottle.up)+ offset;

        // }




        float dist = offset.y;
        if(b.y < a.y)
        {
            a = b;
            b = bottle.transform.position;
        }

        Vector3 heading = b - a;
        float distance = heading.magnitude;
        Vector3 direction = heading / distance;

        planePos = a + direction * dist;
        // plane.transform.position = planePos;



        plane.transform.rotation = Quaternion.Euler(new Vector3(bottle.transform.rotation.x, bottle.transform.rotation.y, bottle.transform.rotation.z));

        liquid.SetVector("_PlanePosition", pos);
        liquid.SetVector("_PlaneNormal", normal);
        
    }
}

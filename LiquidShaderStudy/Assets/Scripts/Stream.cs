using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stream : MonoBehaviour
{
    // Start is called before the first frame update
    public LineRenderer lineRender;
    private Vector3 targetPosition = Vector3.zero;

    
    private void awake()
    {
        lineRender = GetComponent<LineRenderer>();
    }

    private void Start()
    {
        MoveToPosition(0, this.transform.position);
        MoveToPosition(1, this.transform.position);
    }

    public void Begin()
    {
        StartCoroutine(BeginPour());
    }

    public void DesotryStream()
    {
        Destroy(gameObject);
    }

    private IEnumerator BeginPour()
    {
        while(gameObject.activeSelf)
        {
            targetPosition = FindEndPoint();

            MoveToPosition(0, transform.position);
            MoveToPosition(1, targetPosition);

            yield return null;  

        }
    }

    private Vector3 FindEndPoint()
    {
        RaycastHit hit;

        Ray ray = new Ray(transform.position, Vector3.down);
        
        Physics.Raycast(ray, out hit, 5.0f);

        Vector3 endPoint = hit.collider ? hit.point : ray.GetPoint(5.0f);

        return endPoint;
    }

    private void MoveToPosition(int index, Vector3 targetPosition)
    {
        lineRender.SetPosition(index, targetPosition);
    }




}
